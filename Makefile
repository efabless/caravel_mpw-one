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

# Caravel Root (Default: pwd)
# Need to be overwritten if running the makefile from UPRJ_ROOT,
# If caravel is sub-moduled in the user project, run export CARAVEL_ROOT=$(pwd)/caravel
CARAVEL_ROOT ?= $(shell pwd)

# User project root
UPRJ_ROOT ?= $(shell pwd)

# Build tasks such as make ship, make generate_fill, make set_user_id, make final run in the foreground (1) or background (0)
FOREGROUND ?= 1

# PDK setup configs
THREADS ?= $(shell nproc)
STD_CELL_LIBRARY ?= sky130_fd_sc_hd
SPECIAL_VOLTAGE_LIBRARY ?= sky130_fd_sc_hvl
IO_LIBRARY ?= sky130_fd_io
PRIMITIVES_LIBRARY ?= sky130_fd_pr
SKYWATER_COMMIT ?= c094b6e83a4f9298e47f696ec5a7fd53535ec5eb
OPEN_PDKS_COMMIT ?= 804f48b18519aa67b1f822bdc352ecbad1c056cb
INSTALL_SRAM ?= disabled

.DEFAULT_GOAL := ship
# We need portable GDS_FILE pointers...
.PHONY: ship
ship: check-env uncompress uncompress-caravel
ifeq ($(FOREGROUND),1)
	@echo "Running make ship in the foreground..."
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __ship
	@echo "Make ship completed." 2>&1 | tee -a ./signoff/build/make_ship.out
else
	@echo "Running make ship in the background..."
	nohup $(MAKE) -f $(CARAVEL_ROOT)/Makefile __ship >/dev/null 2>&1 &
	tail -f signoff/build/make_ship.out
	@echo "Make ship completed."  2>&1 | tee -a ./signoff/build/make_ship.out
endif

__ship:
	@echo "###############################################"
	@echo "Generating Caravel GDS (sources are in the 'gds' directory)"
	@sleep 1
#### Runs from the CARAVEL_ROOT mag directory 
	@echo "\
		random seed `$(CARAVEL_ROOT)/scripts/set_user_id.py -report`; \
		drc off; \
		crashbackups stop; \
		gds readonly true; \
		gds rescale false; \
		cif *hier write disable; \
		cif *array write disable; \
		gds read $(UPRJ_ROOT)/gds/user_project_wrapper.gds; \
		load caravel -dereference;\
		cellname list filepath user_id_programming $(UPRJ_ROOT)/mag;\
		cellname list filepath user_id_textblock $(UPRJ_ROOT)/mag;\
		flush user_id_programming;\
		flush user_id_textblock;\
		select top cell;\
		gds write $(UPRJ_ROOT)/gds/caravel.gds; \
		exit;" > $(UPRJ_ROOT)/mag/mag2gds_caravel.tcl
### Runs from CARAVEL_ROOT
	@mkdir -p ./signoff/build
	@cd $(CARAVEL_ROOT)/mag && PDKPATH=${PDK_ROOT}/sky130A magic -noc -dnull $(UPRJ_ROOT)/mag/mag2gds_caravel.tcl 2>&1 | tee $(UPRJ_ROOT)/signoff/build/make_ship.out
###	@rm $(UPRJ_ROOT)/mag/mag2gds_caravel.tcl

truck: check-env uncompress uncompress-caravel
ifeq ($(FOREGROUND),1)
	@echo "Running make truck in the foreground..."
	mkdir -p ./signoff
	mkdir -p ./build
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __truck
	@echo "Make truck completed." 2>&1 | tee -a ./signoff/build/make_truck.out
else
	@echo "Running make truck in the background..."
	mkdir -p ./signoff
	mkdir -p ./build
	nohup $(MAKE) -f $(CARAVEL_ROOT)/Makefile __truck >/dev/null 2>&1 &
	tail -f signoff/build/make_truck.out
	@echo "Make truck completed."  2>&1 | tee -a ./signoff/build/make_truck.out
endif

__truck: 
	@echo "###############################################"
	@echo "Generating Caravan GDS (sources are in the 'gds' directory)"
	@sleep 1
#### Runs from the CARAVEL_ROOT mag directory 
	@echo "\
		random seed `$(CARAVEL_ROOT)/scripts/set_user_id.py -report`; \
		drc off; \
		crashbackups stop; \
		gds readonly true; \
		gds rescale false; \
		cif *hier write disable; \
		cif *array write disable; \
		gds read $(UPRJ_ROOT)/gds/user_analog_project_wrapper.gds; \
		load caravan -dereference;\
		cellname list filepath user_id_programming $(UPRJ_ROOT)/mag;\
		cellname list filepath user_id_textblock $(UPRJ_ROOT)/mag;\
		flush user_id_programming;\
		flush user_id_textblock;\
		select top cell;\
		gds write $(UPRJ_ROOT)/gds/caravan.gds; \
		exit;" > $(UPRJ_ROOT)/mag/mag2gds_caravan.tcl
### Runs from CARAVEL_ROOT
	@mkdir -p ./signoff/build
	@cd $(CARAVEL_ROOT)/mag && PDKPATH=${PDK_ROOT}/sky130A magic -noc -dnull $(UPRJ_ROOT)/mag/mag2gds_caravan.tcl 2>&1 | tee $(UPRJ_ROOT)/signoff/build/make_truck.out
###	@rm $(UPRJ_ROOT)/mag/mag2gds_caravan.tcl

.PHONY: clean
clean:
	cd $(CARAVEL_ROOT)/verilog/dv/caravel/mgmt_soc/ && \
		$(MAKE) -j$(THREADS) clean
	cd $(CARAVEL_ROOT)/verilog/dv/wb_utests/ && \
		$(MAKE) -j$(THREADS) clean


.PHONY: verify
verify:
	cd $(CARAVEL_ROOT)/verilog/dv/caravel/mgmt_soc/ && \
		$(MAKE) -j$(THREADS) all
	cd $(CARAVEL_ROOT)/verilog/dv/wb_utests/ && \
		$(MAKE) -j$(THREADS) all



#####
$(LARGE_FILES_GZ): %.$(ARCHIVE_EXT): %
	@if ! [ $(suffix $<) = ".$(ARCHIVE_EXT)" ]; then\
		$(COMPRESS) $< > /dev/null &&\
		echo "$< -> $@";\
	fi

$(LARGE_FILES_GZ_SPLIT): %.$(ARCHIVE_EXT).00.split: %.$(ARCHIVE_EXT)
	@if [ -n "$$(find "$<" -prune -size +$(FILE_SIZE_LIMIT_MB)M)" ]; then\
		split $< -b $(FILE_SIZE_LIMIT_MB)M $<. -d &&\
		rm $< &&\
		for file in $$(ls $<.*); do mv "$$file" "$$file.split"; done &&\
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

# Needed for targets that are run from UPRJ_ROOT for which caravel isn't submoduled. 
.PHONY: uncompress-caravel
uncompress-caravel:
	cd $(CARAVEL_ROOT) && \
	$(MAKE) uncompress

# Digital Wrapper
# verify that the wrapper was respected
xor-wrapper: uncompress uncompress-caravel
### first erase the user's user_project_wrapper.gds
	sh $(CARAVEL_ROOT)/utils/erase_box.sh gds/user_project_wrapper.gds 0 0 2920 3520
### do the same for the empty wrapper
	sh $(CARAVEL_ROOT)/utils/erase_box.sh $(CARAVEL_ROOT)/gds/user_project_wrapper_empty.gds 0 0 2920 3520
	mkdir -p signoff/user_project_wrapper_xor
### XOR the two resulting layouts
	sh $(CARAVEL_ROOT)/utils/xor.sh \
		$(CARAVEL_ROOT)/gds/user_project_wrapper_empty_erased.gds gds/user_project_wrapper_erased.gds \
		user_project_wrapper user_project_wrapper.xor.xml
	sh $(CARAVEL_ROOT)/utils/xor.sh \
		$(CARAVEL_ROOT)/gds/user_project_wrapper_empty_erased.gds gds/user_project_wrapper_erased.gds \
		user_project_wrapper gds/user_project_wrapper.xor.gds > signoff/user_project_wrapper_xor/xor.log 
	rm $(CARAVEL_ROOT)/gds/user_project_wrapper_empty_erased.gds gds/user_project_wrapper_erased.gds
	mv gds/user_project_wrapper.xor.gds gds/user_project_wrapper.xor.xml signoff/user_project_wrapper_xor
	python $(CARAVEL_ROOT)/utils/parse_klayout_xor_log.py \
		-l signoff/user_project_wrapper_xor/xor.log \
		-o signoff/user_project_wrapper_xor/total.txt
### screenshot the result for convenience
	sh $(CARAVEL_ROOT)/utils/scrotLayout.sh \
		$(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyt \
		signoff/user_project_wrapper_xor/user_project_wrapper.xor.gds
	@cat signoff/user_project_wrapper_xor/total.txt

# Analog Wrapper
# verify that the wrapper was respected
xor-analog-wrapper: uncompress uncompress-caravel
### first erase the user's user_project_wrapper.gds
	sh $(CARAVEL_ROOT)/utils/erase_box.sh gds/user_analog_project_wrapper.gds 0 0 2920 3520 -8 -8 
### do the same for the empty wrapper
	sh $(CARAVEL_ROOT)/utils/erase_box.sh $(CARAVEL_ROOT)/gds/user_analog_project_wrapper_empty.gds 0 0 2920 3520 -8 -8 
	mkdir -p signoff/user_analog_project_wrapper_xor
### XOR the two resulting layouts
	sh $(CARAVEL_ROOT)/utils/xor.sh \
		$(CARAVEL_ROOT)/gds/user_analog_project_wrapper_empty_erased.gds gds/user_analog_project_wrapper_erased.gds \
		user_analog_project_wrapper user_analog_project_wrapper.xor.xml
	sh $(CARAVEL_ROOT)/utils/xor.sh \
		$(CARAVEL_ROOT)/gds/user_analog_project_wrapper_empty_erased.gds gds/user_analog_project_wrapper_erased.gds \
		user_analog_project_wrapper gds/user_analog_project_wrapper.xor.gds > signoff/user_analog_project_wrapper_xor/xor.log 
	rm $(CARAVEL_ROOT)/gds/user_analog_project_wrapper_empty_erased.gds gds/user_analog_project_wrapper_erased.gds
	mv gds/user_analog_project_wrapper.xor.gds gds/user_analog_project_wrapper.xor.xml signoff/user_analog_project_wrapper_xor
	python $(CARAVEL_ROOT)/utils/parse_klayout_xor_log.py \
		-l signoff/user_analog_project_wrapper_xor/xor.log \
		-o signoff/user_analog_project_wrapper_xor/total.txt
### screenshot the result for convenience
	sh $(CARAVEL_ROOT)/utils/scrotLayout.sh \
		$(PDK_ROOT)/sky130A/libs.tech/klayout/sky130A.lyt \
		signoff/user_analog_project_wrapper_xor/user_analog_project_wrapper.xor.gds
	@cat signoff/user_analog_project_wrapper_xor/total.txt

# LVS
BLOCKS = $(shell cd openlane && find * -maxdepth 0 -type d)
LVS_BLOCKS = $(foreach block, $(BLOCKS), lvs-$(block))
$(LVS_BLOCKS): lvs-% : ./mag/%.mag ./verilog/gl/%.v
	echo "Extracting $*"
	mkdir -p ./mag/tmp
	echo "addpath $(CARAVEL_ROOT)/mag/hexdigits;\
		addpath $(CARAVEL_ROOT)/subcells/simple_por/mag;\
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
		magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc -noc -dnull extract_$*.tcl < /dev/null
	mv ./mag/$*.spice ./spi/lvs
	rm ./mag/*.ext
	mv -f ./mag/extract_$*.tcl ./mag/tmp
	mv -f ./mag/extract_$*.log ./mag/tmp
	####
	mkdir -p ./spi/lvs/tmp
	sh $(CARAVEL_ROOT)/spi/lvs/run_lvs.sh ./spi/lvs/$*.spice ./verilog/gl/$*.v $*
	@echo ""
	python3 $(CARAVEL_ROOT)/scripts/count_lvs.py -f ./verilog/gl/$*.v_comp.json | tee ./spi/lvs/tmp/$*.lvs.summary.log
	mv -f ./verilog/gl/*.out ./spi/lvs/tmp 2> /dev/null || true
	mv -f ./verilog/gl/*.json ./spi/lvs/tmp 2> /dev/null || true
	mv -f ./verilog/gl/*.log ./spi/lvs/tmp 2> /dev/null || true
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
		magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc -noc -dnull extract_$*.tcl < /dev/null
	mv ./gds/$*.spice ./spi/lvs
	rm ./gds/*.ext
	mv -f ./gds/extract_$*.tcl ./gds/tmp
	mv -f ./gds/extract_$*.log ./gds/tmp
	####
	mkdir -p ./spi/lvs/tmp
	MAGIC_EXT_USE_GDS=1 sh $(CARAVEL_ROOT)/spi/lvs/run_lvs.sh ./spi/lvs/$*.spice ./verilog/gl/$*.v $*
	@echo ""
	python3 $(CARAVEL_ROOT)/scripts/count_lvs.py -f ./verilog/gl/$*.v_comp.json | tee ./spi/lvs/tmp/$*.lvs.summary.log
	mv -f ./verilog/gl/*.out ./spi/lvs/tmp 2> /dev/null || true
	mv -f ./verilog/gl/*.json ./spi/lvs/tmp 2> /dev/null || true
	mv -f ./verilog/gl/*.log ./spi/lvs/tmp 2> /dev/null || true
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
	mv -f ./mag/extract_$*.tcl ./maglef/tmp
	mv -f ./mag/extract_$*.log ./maglef/tmp
	####
	mkdir -p ./spi/lvs/tmp
	sh $(CARAVEL_ROOT)/spi/lvs/run_lvs.sh ./spi/lvs/$*.spice ./verilog/gl/$*.v $*
	@echo ""
	python3 $(CARAVEL_ROOT)/scripts/count_lvs.py -f ./verilog/gl/$*.v_comp.json | tee ./spi/lvs/tmp/$*.maglef.lvs.summary.log
	mv -f ./verilog/gl/*.out ./spi/lvs/tmp 2> /dev/null || true
	mv -f ./verilog/gl/*.json ./spi/lvs/tmp 2> /dev/null || true
	mv -f ./verilog/gl/*.log ./spi/lvs/tmp 2> /dev/null || true
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
	cd gds && export DESIGN_IN_DRC=$* && export MAGTYPE=mag; magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc -noc -dnull $(CARAVEL_ROOT)/gds/drc_on_gds.tcl < /dev/null
	@echo "DRC result: ./gds/tmp/$*.drc"

# Antenna
BLOCKS = $(shell cd openlane && find * -maxdepth 0 -type d)
ANTENNA_BLOCKS = $(foreach block, $(BLOCKS), antenna-$(block))
$(ANTENNA_BLOCKS): antenna-% : ./gds/%.gds
	echo "Running Antenna Checks on $*"
	mkdir -p ./gds/tmp
	cd gds && export DESIGN_IN_ANTENNA=$* && export MAGTYPE=mag; magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc -noc -dnull $(CARAVEL_ROOT)/gds/antenna_on_gds.tcl < /dev/null 2>&1 | tee ./tmp/$*.antenna
	mv -f ./gds/*.ext ./gds/tmp/
	@echo "Antenna result: ./gds/tmp/$*.antenna"

# MAG2GDS
BLOCKS = $(shell cd openlane && find * -maxdepth 0 -type d)
MAG_BLOCKS = $(foreach block, $(BLOCKS), mag2gds-$(block))
$(MAG_BLOCKS): mag2gds-% : ./mag/%.mag uncompress
	echo "Converting mag file $* to GDS..."
	echo "addpath $(CARAVEL_ROOT)/mag/hexdigits;\
		addpath ${PDKPATH}/libs.ref/sky130_ml_xx_hd/mag;\
		addpath ${CARAVEL_ROOT}/subcells/simple_por/mag;\
		drc off;\
		gds rescale false;\
		load $* -dereference;\
		select top cell;\
		expand;\
		cif *hier write disable;\
		gds write $*.gds;\
		exit;" > ./mag/mag2gds_$*.tcl
	cd ./mag && magic -rcfile ${PDK_ROOT}/sky130A/libs.tech/magic/sky130A.magicrc -noc -dnull mag2gds_$*.tcl < /dev/null
	rm ./mag/mag2gds_$*.tcl
	mv -f ./mag/$*.gds ./gds/
	
.PHONY: help
help:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: generate_fill
generate_fill: check-env check-uid check-project uncompress
ifeq ($(FOREGROUND),1)
	@echo "Running generate_fill in the foreground..."
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __generate_fill
	@echo "Generate fill completed." 2>&1 | tee -a ./signoff/build/generate_fill.out
else
	@echo "Running generate_fill in the background..."
	@nohup $(MAKE) -f $(CARAVEL_ROOT)/Makefile __generate_fill >/dev/null 2>&1 &
	tail -f signoff/build/generate_fill.out
	@echo "Generate fill completed." | tee -a signoff/build/generate_fill.out
endif

__generate_fill:
	@mkdir -p ./signoff/build
	@cp -r $(CARAVEL_ROOT)/mag/.magicrc $(shell pwd)/mag
	python3 $(CARAVEL_ROOT)/scripts/generate_fill.py $(USER_ID) $(PROJECT) $(shell pwd) -dist 2>&1 | tee ./signoff/build/generate_fill.out
	#python3 $(CARAVEL_ROOT)/scripts/generate_fill.py $(USER_ID) $(PROJECT) $(shell pwd) -keep 2>&1 | tee ./signoff/build/generate_fill.out


.PHONY: final
final: check-env check-uid check-project uncompress uncompress-caravel
ifeq ($(FOREGROUND),1)
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __final
	@echo "Final build completed." 2>&1 | tee -a ./signoff/build/final_build.out
else
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __final >/dev/null 2>&1 &
	tail -f signoff/build/final_build.out
	@echo "Final build completed." 2>&1 | tee -a ./signoff/build/final_build.out
endif

__final:
	python3 $(CARAVEL_ROOT)/scripts/compositor.py $(USER_ID) $(PROJECT) $(shell pwd) $(CARAVEL_ROOT)/mag $(shell pwd)/gds -keep
	#mv $(CARAVEL_ROOT)/mag/caravel_$(USER_ID).mag ./mag/
	@rm -rf ./mag/tmp

.PHONY: set_user_id
set_user_id: check-env check-uid uncompress uncompress-caravel
ifeq ($(FOREGROUND),1)
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __set_user_id
	@echo "Set user ID completed." 2>&1 | tee -a ./signoff/build/set_user_id.out
else
	$(MAKE) -f $(CARAVEL_ROOT)/Makefile __set_user_id >/dev/null 2>&1 &
	tail -f signoff/build/set_user_id.out
	@echo "Set user ID completed." 2>&1 | tee -a ./signoff/build/set_user_id.out
endif

__set_user_id: 
	mkdir -p ./signoff/build
	# Update info.yaml
	# sed -r "s/^(\s*project_id\s*:\s*).*/\1${USER_ID}/" -i info.yaml
	cp $(CARAVEL_ROOT)/gds/user_id_programming.gds ./gds/user_id_programming.gds
	cp $(CARAVEL_ROOT)/mag/user_id_programming.mag ./mag/user_id_programming.mag
	cp $(CARAVEL_ROOT)/mag/user_id_textblock.mag ./mag/user_id_textblock.mag
	cp $(CARAVEL_ROOT)/verilog/rtl/caravel.v ./verilog/rtl/caravel.v
	python3 $(CARAVEL_ROOT)/scripts/set_user_id.py $(USER_ID) $(shell pwd) 2>&1 | tee ./signoff/build/set_user_id.out

.PHONY: update_caravel
update_caravel:
	cd caravel/ && \
		git checkout master && \
		git pull

###########################################################################
.PHONY: pdk
pdk: skywater-pdk skywater-library skywater-timing open_pdks build-pdk gen-sources

$(PDK_ROOT)/skywater-pdk:
	git clone https://github.com/google/skywater-pdk.git $(PDK_ROOT)/skywater-pdk

.PHONY: skywater-pdk
skywater-pdk: check-env $(PDK_ROOT)/skywater-pdk
	cd $(PDK_ROOT)/skywater-pdk && \
		git checkout main && git pull && \
		git checkout -qf $(SKYWATER_COMMIT)

.PHONY: skywater-library
skywater-library: check-env $(PDK_ROOT)/skywater-pdk
	cd $(PDK_ROOT)/skywater-pdk && \
		git submodule update --init libraries/$(STD_CELL_LIBRARY)/latest && \
		git submodule update --init libraries/$(IO_LIBRARY)/latest && \
		git submodule update --init libraries/$(SPECIAL_VOLTAGE_LIBRARY)/latest && \
		git submodule update --init libraries/$(PRIMITIVES_LIBRARY)/latest

gen-sources: $(PDK_ROOT)/sky130A
	touch $(PDK_ROOT)/sky130A/SOURCES
	echo -ne "skywater-pdk " >> $(PDK_ROOT)/sky130A/SOURCES
	cd $(PDK_ROOT)/skywater-pdk && git rev-parse HEAD >> $(PDK_ROOT)/sky130A/SOURCES
	echo -ne "open_pdks " >> $(PDK_ROOT)/sky130A/SOURCES
	cd $(PDK_ROOT)/open_pdks && git rev-parse HEAD >> $(PDK_ROOT)/sky130A/SOURCES

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
		./configure --enable-sky130-pdk=$(PDK_ROOT)/skywater-pdk/libraries --with-sky130-local-path=$(PDK_ROOT) --enable-sram-sky130=$(INSTALL_SRAM) && \
		cd sky130 && \
		$(MAKE) veryclean && \
		$(MAKE) && \
		$(MAKE) install-local && \
		$(MAKE) clean

.RECIPE: manifest
manifest: mag/ maglef/ verilog/rtl/ Makefile
	touch manifest && \
	find verilog/rtl/* -type f ! -name "caravel_netlists.v" ! -name "user_*.v" ! -name "README" ! -name "defines.v" -exec shasum {} \; > manifest && \
	shasum scripts/set_user_id.py scripts/generate_fill.py scripts/compositor.py >> manifest
# shasum lef/user_project_wrapper_empty.lef >> manifest
# find maglef/*.mag -type f ! -name "user_project_wrapper.mag" -exec shasum {} \; >> manifest && \
# shasum mag/caravel.mag mag/.magicrc >> manifest

.RECIPE: master_manifest
master_manifest:
	find verilog/rtl/* -type f -exec shasum {} \; > master_manifest && \
	find verilog/gl/* -type f -exec shasum {} \; >> master_manifest && \
	shasum scripts/set_user_id.py scripts/generate_fill.py scripts/compositor.py >> master_manifest && \
	find lef/*.lef -type f -exec shasum {} \; >> master_manifest && \
	find def/*.def -type f -exec shasum {} \; >> master_manifest && \
	find mag/*.mag -type f  -exec shasum {} \; >> master_manifest && \
	find maglef/*.mag -type f -exec shasum {} \; >> master_manifest && \
	find spi/lvs/*.spice -type f -exec shasum {} \; >> master_manifest && \
	find gds/*.gds -type f -exec shasum {} \; >> master_manifest 
	
check-env:
ifndef PDK_ROOT
	$(error PDK_ROOT is undefined, please export it before running make)
endif

check-uid:
ifndef USER_ID
	$(error USER_ID is undefined, please export it before running make set_user_id)
else 
	@echo USER_ID is set to $(USER_ID)
endif

check-project:
ifndef PROJECT
	$(error PROJECT is undefined, please export it before running make generate_fill or make final)
else
	@echo PROJECT is set to $(PROJECT)
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
