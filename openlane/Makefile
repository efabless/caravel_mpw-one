BLOCKS = chip_io user_project_wrapper digital_pll mgmt_core
CONFIG = $(foreach block,$(BLOCKS), ./$(block)/config.tcl)
CLEAN = $(foreach block,$(BLOCKS), clean-$(block))

all: $(BLOCKS)

$(CONFIG) :
	@echo "Missing $@. Please create a configuration for that design"
	@exit 1

$(BLOCKS) : % : ./%/config.tcl FORCE
ifeq ($(OPENLANE_ROOT),)
	@echo "Please export OPENLANE_ROOT"
	@exit 1
endif
	@echo "###############################################"
	@sleep 1
	if [[ -f ./$*/interactive.tcl ]]; then\
		${OPENLANE_ROOT}/flow.tcl -it -file ./$*/interactive.tcl;\
	else\
		${OPENLANE_ROOT}/flow.tcl -design ./$* -save_path .. -save -tag $* -overwrite;\
	fi

FORCE:

clean: 
	@echo "Use clean_all to clean everything :)"

clean_all: $(CLEAN)

$(CLEAN): clean-% :
	rm -rf runs/$*
	rm -rf ../gds/$**
	rm -rf ../mag/$**
	rm -rf ../lef/$**
