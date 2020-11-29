BLOCKS = $(shell find * -maxdepth 0 -type d)
CONFIG = $(foreach block,$(BLOCKS), ./$(block)/config.tcl)
CLEAN = $(foreach block,$(BLOCKS), clean-$(block))

OPENLANE_TAG ?= rc5
OPENLANE_IMAGE_NAME ?= openlane:$(OPENLANE_TAG)
OPENLANE_BASIC_COMMAND = "cd /project/openlane && flow.tcl -design ./$* -save_path .. -save -tag $* -overwrite"
OPENLANE_INTERACTIVE_COMMAND = "cd /project/openlane && flow.tcl -it -file ./$*/interactive.tcl"

all: $(BLOCKS)

$(CONFIG) :
	@echo "Missing $@. Please create a configuration for that design"
	@exit 1

$(BLOCKS) : % : ./%/config.tcl FORCE
ifeq ($(OPENLANE_ROOT),)
	@echo "Please export OPENLANE_ROOT"
	@exit 1
endif
ifeq ($(PDK_ROOT),)
	@echo "Please export PDK_ROOT"
	@exit 1
endif
	@echo "###############################################"
	@sleep 1

	@if [ -f ./$*/interactive.tcl ]; then\
		docker run -it -v $(OPENLANE_ROOT):/openLANE_flow \
		-v $(PDK_ROOT):$(PDK_ROOT) \
		-v $(PWD)/..:/project \
		-e PDK_ROOT=$(PDK_ROOT) \
		-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
		$(OPENLANE_IMAGE_NAME) sh -c $(OPENLANE_INTERACTIVE_COMMAND);\
	else\
		docker run -it -v $(OPENLANE_ROOT):/openLANE_flow \
		-v $(PDK_ROOT):$(PDK_ROOT) \
		-v $(PWD)/..:/project \
		-e PDK_ROOT=$(PDK_ROOT) \
		-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
		$(OPENLANE_IMAGE_NAME) sh -c $(OPENLANE_BASIC_COMMAND);\
	fi

.PHONY: openlane
openlane:
ifeq ($(OPENLANE_ROOT),)
	@echo "Please export OPENLANE_ROOT"
	@exit 1
endif
	git clone https://github.com/efabless/openlane.git --branch=develop $(OPENLANE_ROOT) && \
		cd $(OPENLANE_ROOT) && \
		make openlane

FORCE:

clean: 
	@echo "Use clean_all to clean everything :)"

clean_all: $(CLEAN)

$(CLEAN): clean-% :
	rm -rf runs/$*
	rm -rf ../gds/$**
	rm -rf ../mag/$**
	rm -rf ../lef/$**
