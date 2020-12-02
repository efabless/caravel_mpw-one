# ---- Test patterns for project striVe ----

.SUFFIXES:
.SILENT: clean all

PATTERNS = gpio mem uart perf hkspi sysctrl mprj_ctrl pass_thru timer timer2 pll storage

all:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i && SIM=RTL make -f Makefile $${i}.vcd &> verify.log && grep Monitor verify.log) ; \
		( cd $$i && SIM=GL make -f Makefile $${i}.vcd &> verify.log && grep Monitor verify.log) ; \
	done

clean:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i && make clean ) ; \
	done

.PHONY: clean all
