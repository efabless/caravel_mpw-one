# ---- Test patterns for project striVe ----

.SUFFIXES:
.SILENT: clean all

PATTERNS = gpio_wb intercon_wb  spimemio_wb uart_wb  crossbar_wb arbiter_wb

all:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i && make -f Makefile $${i}.vcd &> verify.log && grep Monitor verify.log) ; \
	done

clean:  ${PATTERNS}
	for i in ${PATTERNS}; do \
		( cd $$i && make clean ) ; \
	done

.PHONY: clean all
