# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# cannot commit files larger than 100 MB to GitHub
FILE_SIZE_LIMIT_MB = 100

# Commands to be used to compress/uncompress files
# they must operate **in place** (otherwise, modify the target to delete the
# intermediate file/archive)
COMPRESS ?= gzip -n --best
UNCOMPRESS ?= gzip -d
ARCHIVE_EXT ?= gz

# The following variables are to build static pattern rules

# Needed to rebuild archives that were previously split
SPLIT_FILES := $(shell find . -type f -name "*.$(ARCHIVE_EXT).00.split")
SPLIT_FILES_SOURCES := $(basename $(basename $(basename $(SPLIT_FILES))))

# Needed to uncompress the existing archives
ARCHIVES := $(shell find . -type f -name "*.$(ARCHIVE_EXT)")
ARCHIVE_SOURCES := $(basename $(ARCHIVES))

# Needed to compress and split files/archives that are too large
LARGE_FILES := $(shell find ./gds -type f -name "*.gds")
LARGE_FILES += $(shell find . -type f -size +$(FILE_SIZE_LIMIT_MB)M -not -path "./.git/*" -not -path "./gds/*" -not -path "./openlane/*")
LARGE_FILES_GZ := $(addsuffix .$(ARCHIVE_EXT), $(LARGE_FILES))
LARGE_FILES_GZ_SPLIT := $(addsuffix .$(ARCHIVE_EXT).00.split, $(LARGE_FILES))
# consider splitting existing archives
LARGE_FILES_GZ_SPLIT += $(addsuffix .00.split, $(ARCHIVES))

# User ID
USER_ID ?= 0

# PDK setup configs
THREADS ?= $(shell nproc)
STD_CELL_LIBRARY ?= sky130_fd_sc_hd
SPECIAL_VOLTAGE_LIBRARY ?= sky130_fd_sc_hvl
IO_LIBRARY ?= sky130_fd_io
SKYWATER_COMMIT ?= f6f76f3dc99526c6fc2cfede19b5b1227d4ebde7
OPEN_PDKS_COMMIT ?= ec43817ed9f58ff83c9d260ce981818023cb6d77

.DEFAULT_GOAL := ship
# We need portable GDS_FILE pointers...
.PHONY: ship
ship: check-env uncompress
	@echo "###############################################"
	@echo "Generating Caravel GDS (sources are in the 'gds' directory)"
	@sleep 1
	@echo "\
		random seed `scripts/set_user_id.py -report`; \
		gds readonly true; \
		gds rescale false; \
		gds read ../gds/user_project_wrapper.gds; \
		load caravel -dereference;\
		select top cell;\
		gds write caravel.gds; \
		exit;" > ./mag/mag2gds_caravel.tcl
	@cd mag && PDKPATH=${PDK_ROOT}/sky130A magic -noc -dnull mag2gds_caravel.tcl < /dev/null
	@rm ./mag/mag2gds_caravel.tcl
	@mv -f ./gds/caravel.gds ./gds/caravel.old.gds
	mv ./mag/caravel.gds ./gds

.PHONY: clean
clean:
	cd ./verilog/dv/caravel/mgmt_soc/ && \
		$(MAKE) -j$(THREADS) clean
	cd ./verilog/dv/caravel/user_proj_example/ && \
		$(MAKE) -j$(THREADS) clean
	cd ./verilog/dv/wb_utests/ && \
		$(MAKE) -j$(THREADS) clean


.PHONY: verify
verify:
	cd ./verilog/dv/caravel/mgmt_soc/ && \
		$(MAKE) -j$(THREADS) all
	cd ./verilog/dv/caravel/user_proj_example/ && \
		$(MAKE) -j$(THREADS) all
	cd ./verilog/dv/wb_utests/ && \
		$(MAKE) -j$(THREADS) all



#####
$(LARGE_FILES_GZ): %.$(ARCHIVE_EXT): %
	@if ! [ $(suffix $<) = ".$(ARCHIVE_EXT)" ]; then\
		$(COMPRESS) $< > /dev/null &&\
		echo "$< -> $@";\
	fi

$(LARGE_FILES_GZ_SPLIT): %.$(ARCHIVE_EXT).00.split: %.$(ARCHIVE_EXT)
	@if [ -n "$$(find "$<" -prune -size +$(FILE_SIZE_LIMIT_MB)M)" ]; then\
		split $< -b $(FILE_SIZE_LIMIT_MB)M $<. -d --additional-suffix=.split &&\
		rm $< &&\
		echo -n "$< -> $$(ls $<.*.split)" | tr '\n' ' ' && echo "";\
	fi

# This target compresses all files larger than $(FILE_SIZE_LIMIT_MB) MB
.PHONY: compress
compress: $(LARGE_FILES_GZ) $(LARGE_FILES_GZ_SPLIT)
	@echo "Files larger than $(FILE_SIZE_LIMIT_MB) MBytes are compressed!"



#####
$(ARCHIVE_SOURCES): %: %.$(ARCHIVE_EXT)
	@$(UNCOMPRESS) $<
	@echo "$< -> $@"

.SECONDEXPANSION:
$(SPLIT_FILES_SOURCES): %: $$(sort $$(wildcard %.$(ARCHIVE_EXT).*.split))
	@cat $? > $@.$(ARCHIVE_EXT)
	@rm $?
	@echo "$? -> $@.$(ARCHIVE_EXT)"
	@$(UNCOMPRESS) $@.$(ARCHIVE_EXT)
	@echo "$@.$(ARCHIVE_EXT) -> $@"


.PHONY: uncompress
uncompress: $(SPLIT_FILES_SOURCES) $(ARCHIVE_SOURCES)
	@echo "All files are uncompressed!"


# verify that the wrapper was respected
xor-wrapper:
	# first erase the user's user_project_wrapper.gds
	sh utils/erase_box.sh gds/user_project_wrapper.gds 0 0 2920 3520
	# do the same for the empty wrapper
	sh utils/erase_box.sh gds/user_project_wrapper_empty.gds 0 0 2920 3520
	mkdir -p signoff/user_project_wrapper_xor
	# XOR the two resulting layouts
	sh utils/xor.sh \
		gds/user_project_wrapper_empty_erased.gds gds/user_project_wrapper_erased.gds \
		user_project_wrapper user_project_wrapper.xor.xml
	sh utils/xor.sh \
		gds/user_project_wrapper_empty_erased.gds gds/user_project_wrapper_erased.gds \
		user_project_wrapper gds/user_project_wrapper.xor.gds > signoff/user_project_wrapper_xor/xor.log
	rm gds/user_project_wrapper_empty_erased.gds gds/user_project_wrapper_erased.gds
	mv gds/user_project_wrapper.xor.gds gds/user_project_wrapper.xor.xml signoff/user_project_wrapper_xor
	python utils/parse_klayout_xor_log.py \
		-l signoff/user_project_wrapper_xor/xor.log \
		-o signoff/user_project_wrapper_xor/total.txt
	# screenshot the result for convenience
	sh utils/scrotLayout.sh \
		$(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyt \
		signoff/user_project_wrapper_xor/user_project_wrapper.xor.gds
	@cat signoff/user_project_wrapper_xor/total.txt

# LVS
BLOCKS = $(shell cd openlane && find * -maxdepth 0 -type d)
LVS_BLOCKS = $(foreach block, $(BLOCKS), lvs-$(block))
$(LVS_BLOCKS): lvs-% : ./mag/%.mag ./verilog/gl/%.v
	echo "Extracting $*"
	mkdir -p ./mag/tmp
	echo "addpath hexdigits;\
		addpath \$$PDKPATH/libs.ref/sky130_ml_xx_hd/mag;\
		load $* -dereference;\
		select top cell;\
		foreach cell [cellname list children] {\
			load \$$cell -dereference;\
			property LEFview TRUE;\
		};\
		load $* -dereference;\
		select top cell;\
		extract no all;\
		extract do local;\
		extract unique;\
		extract;\
		ext2spice lvs;\
		ext2spice $*.ext;\
		feedback save extract_$*.log;\
		exit;" > ./mag/extract_$*.tcl
	cd mag && \
		export MAGTYPE=maglef; \
		magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/current/sky130A.magicrc -noc -dnull extract_$*.tcl < /dev/null
	mv ./mag/$*.spice ./spi/lvs
	rm ./mag/*.ext
	mv -f ./mag/extract_$*.{tcl,log} ./mag/tmp
	####
	mkdir -p ./spi/lvs/tmp
	sh ./spi/lvs/run_lvs.sh ./spi/lvs/$*.spice ./verilog/gl/$*.v $*
	@echo ""
	python3 ./scripts/count_lvs.py -f ./verilog/gl/$*.v_comp.json | tee ./spi/lvs/tmp/$*.lvs.summary.log
	mv -f ./verilog/gl/*{.out,.json,.log} ./spi/lvs/tmp 2> /dev/null || true
	@echo ""
	@echo "LVS: ./spi/lvs/$*.spice vs. ./verilog/gl/$*.v"
	@echo "Comparison result: ./spi/lvs/tmp/$*.v_comp.out"
	@awk '/^NET mismatches/,0' ./spi/lvs/tmp/$*.v_comp.out


LVS_GDS_BLOCKS = $(foreach block, $(BLOCKS), lvs-gds-$(block))
$(LVS_GDS_BLOCKS): lvs-gds-% : ./gds/%.gds ./verilog/gl/%.v
	echo "Extracting $*"
	mkdir -p ./gds/tmp
	echo "gds read ./$*.gds;\
		load $* -dereference;\
		select top cell;\
		extract no all;\
		extract do local;\
		extract unique;\
		extract;\
		ext2spice lvs;\
		ext2spice $*.ext;\
		feedback save extract_$*.log;\
		exit;" > ./gds/extract_$*.tcl
	cd gds && \
		magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/current/sky130A.magicrc -noc -dnull extract_$*.tcl < /dev/null
	mv ./gds/$*.spice ./spi/lvs
	rm ./gds/*.ext
	mv -f ./gds/extract_$*.{tcl,log} ./gds/tmp
	####
	mkdir -p ./spi/lvs/tmp
	MAGIC_EXT_USE_GDS=1 sh ./spi/lvs/run_lvs.sh ./spi/lvs/$*.spice ./verilog/gl/$*.v $*
	@echo ""
	python3 ./scripts/count_lvs.py -f ./verilog/gl/$*.v_comp.json | tee ./spi/lvs/tmp/$*.lvs.summary.log
	mv -f ./verilog/gl/*{.out,.json,.log} ./spi/lvs/tmp 2> /dev/null || true
	@echo ""
	@echo "LVS: ./spi/lvs/$*.spice vs. ./verilog/gl/$*.v"
	@echo "Comparison result: ./spi/lvs/tmp/$*.v_comp.out"
	@awk '/^NET mismatches/,0' ./spi/lvs/tmp/$*.v_comp.out


# connect-by-label is enabled here!
LVS_MAGLEF_BLOCKS = $(foreach block, $(BLOCKS), lvs-maglef-$(block))
$(LVS_MAGLEF_BLOCKS): lvs-maglef-% : ./mag/%.mag ./verilog/gl/%.v
	echo "Extracting $*"
	mkdir -p ./maglef/tmp
	echo "load $* -dereference;\
		select top cell;\
		foreach cell [cellname list children] {\
			load \$$cell -dereference;\
			property LEFview TRUE;\
		};\
		load $* -dereference;\
		select top cell;\
		extract no all;\
		extract do local;\
		extract;\
		ext2spice lvs;\
		ext2spice $*.ext;\
		feedback save extract_$*.log;\
		exit;" > ./mag/extract_$*.tcl
	cd mag && export MAGTYPE=maglef; magic -noc -dnull extract_$*.tcl < /dev/null
	mv ./mag/$*.spice ./spi/lvs
	rm ./maglef/*.ext
	mv -f ./mag/extract_$*.{tcl,log} ./maglef/tmp
	####
	mkdir -p ./spi/lvs/tmp
	sh ./spi/lvs/run_lvs.sh ./spi/lvs/$*.spice ./verilog/gl/$*.v $*
	@echo ""
	python3 ./scripts/count_lvs.py -f ./verilog/gl/$*.v_comp.json | tee ./spi/lvs/tmp/$*.maglef.lvs.summary.log
	mv -f ./verilog/gl/*{.out,.json,.log} ./spi/lvs/tmp 2> /dev/null || true
	@echo ""
	@echo "LVS: ./spi/lvs/$*.spice vs. ./verilog/gl/$*.v"
	@echo "Comparison result: ./spi/lvs/tmp/$*.v_comp.out"
	@awk '/^NET mismatches/,0' ./spi/lvs/tmp/$*.v_comp.out

# DRC
BLOCKS = $(shell cd openlane && find * -maxdepth 0 -type d)
DRC_BLOCKS = $(foreach block, $(BLOCKS), drc-$(block))
$(DRC_BLOCKS): drc-% : ./gds/%.gds
	echo "Running DRC on $*"
	mkdir -p ./gds/tmp
	cd gds && export DESIGN_IN_DRC=$* && export MAGTYPE=mag; magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/current/sky130A.magicrc -noc -dnull drc_on_gds.tcl < /dev/null
	@echo "DRC result: ./gds/tmp/$*.drc"

# Antenna
BLOCKS = $(shell cd openlane && find * -maxdepth 0 -type d)
ANTENNA_BLOCKS = $(foreach block, $(BLOCKS), antenna-$(block))
$(ANTENNA_BLOCKS): antenna-% : ./gds/%.gds
	echo "Running Antenna Checks on $*"
	mkdir -p ./gds/tmp
	cd gds && export DESIGN_IN_ANTENNA=$* && export MAGTYPE=mag; magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/current/sky130A.magicrc -noc -dnull antenna_on_gds.tcl < /dev/null 2>&1 | tee ./tmp/$*.antenna
	mv -f ./gds/*.ext ./gds/tmp/
	@echo "Antenna result: ./gds/tmp/$*.antenna"

.PHONY: help
help:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: generate_fill
generate_fill:
	python3 ./scripts/generate_fill.py $(shell pwd)

.PHONY: compose
compose:
	python3 ./scripts/compositor.py $(shell pwd)

.PHONY: set_user_id
set_user_id:
	python3 ./scripts/set_user_id.py $(USER_ID) $(shell pwd)

.PHONY: update_caravel
update_caravel:
	cd caravel/ && \
		git checkout master && \
		git pull

###########################################################################
.PHONY: pdk
pdk: skywater-pdk skywater-library skywater-timing open_pdks build-pdk

$(PDK_ROOT)/skywater-pdk:
	git clone https://github.com/google/skywater-pdk.git $(PDK_ROOT)/skywater-pdk

.PHONY: skywater-pdk
skywater-pdk: check-env $(PDK_ROOT)/skywater-pdk
	cd $(PDK_ROOT)/skywater-pdk && \
		git checkout master && git pull && \
		git checkout -qf $(SKYWATER_COMMIT)

.PHONY: skywater-library
skywater-library: check-env $(PDK_ROOT)/skywater-pdk
	cd $(PDK_ROOT)/skywater-pdk && \
		git submodule update --init libraries/$(STD_CELL_LIBRARY)/latest && \
		git submodule update --init libraries/$(IO_LIBRARY)/latest && \
		git submodule update --init libraries/$(SPECIAL_VOLTAGE_LIBRARY)/latest

skywater-timing: check-env $(PDK_ROOT)/skywater-pdk
	cd $(PDK_ROOT)/skywater-pdk && \
		$(MAKE) timing
### OPEN_PDKS
$(PDK_ROOT)/open_pdks:
	git clone git://opencircuitdesign.com/open_pdks $(PDK_ROOT)/open_pdks

.PHONY: open_pdks
open_pdks: check-env $(PDK_ROOT)/open_pdks
	cd $(PDK_ROOT)/open_pdks && \
		git checkout master && git pull && \
		git checkout -qf $(OPEN_PDKS_COMMIT)

.PHONY: build-pdk
build-pdk: check-env $(PDK_ROOT)/open_pdks $(PDK_ROOT)/skywater-pdk
	[ -d $(PDK_ROOT)/sky130A ] && \
		(echo "Warning: A sky130A build already exists under $(PDK_ROOT). It will be deleted first!" && \
		sleep 5 && \
		rm -rf $(PDK_ROOT)/sky130A) || \
		true
	cd $(PDK_ROOT)/open_pdks && \
		./configure --enable-alpha-lib --enable-sky130-pdk=$(PDK_ROOT)/skywater-pdk/libraries --with-sky130-local-path=$(PDK_ROOT) && \
		cd sky130 && \
		sed -i 's/REPO_PATH = ~\/gits/REPO_PATH = \$$\(PDK_ROOT\)\/open_pdks\/libs/g' Makefile && \
		$(MAKE) veryclean && \
		$(MAKE) && \
		$(MAKE) install-local && \
		$(MAKE) clean

.RECIPE: manifest
manifest: mag/ maglef/ verilog/rtl/ scripts/ Makefile
	touch manifest && \
	find verilog/rtl/* -type f ! -name "caravel_netlists.v" ! -name "user_*.v" ! -name "README" ! -name "defines.v" -exec shasum {} \; > manifest && \
	find maglef/*.mag -type f ! -name "user_project_wrapper.mag" -exec shasum {} \; >> manifest && \
	shasum mag/caravel.mag mag/.magicrc >> manifest
	shasum scripts/set_user_id.py scripts/generate_fill.py scripts/compositor.py >> manifest
	shasum lef/user_project_wrapper_empty.lef >> manifest

check-env:
ifndef PDK_ROOT
	$(error PDK_ROOT is undefined, please export it before running make)
endif

# Make README.rst
README.rst: README.src.rst docs/source/getting-started.rst docs/source/tool-versioning.rst openlane/README.src.rst docs/source/caravel-with-openlane.rst Makefile
	pip -q install rst_include && \
	rm -f README.rst && \
		rst_include include README.src.rst - | \
			sed \
				-e's@\.\/\_static@\/docs\/source\/\_static@g' \
				-e's@:doc:`tool-versioning`@`tool-versioning.rst <./docs/source/tool-versioning.rst>`__@g' \
				-e's@.. note::@**NOTE:**@g' \
				-e's@.. warning::@**WARNING:**@g' \
				> README.rst && \
		rst_include include openlane/README.src.rst - | \
			sed \
				-e's@https://github.com/efabless/caravel/blob/master/verilog@../verilog@g' \
				-e's@:ref:`getting-started`@`README.rst <../README.rst>`__@g' \
				-e's@https://github.com/efabless/caravel/blob/master/openlane/@./@g' \
				-e's@.. note::@**NOTE:**@g' \
				-e's@.. warning::@**WARNING:**@g' \
				> openlane/README.rst
