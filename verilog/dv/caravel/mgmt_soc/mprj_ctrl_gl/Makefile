FIRMWARE_PATH = ../..
VERILOG_PATH = ../../../..
RTL_PATH = $(VERILOG_PATH)/rtl
IP_PATH = ../../../../ip
BEHAVIOURAL_MODELS = ../../ 

GCC_PATH?=/ef/apps/bin
GCC_PREFIX?=riscv32-unknown-elf
PDK_PATH?=/ef/tech/SW/sky130A

.SUFFIXES:

PATTERN = mprj_ctrl

all:  ${PATTERN:=.vcd}

hex:  ${PATTERN:=.hex}

%.vvp: %_tb.v %.hex
	iverilog -DFUNCTIONAL -DUSE_POWER_PINS -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(VERILOG_PATH) -I $(RTL_PATH) \
	$< -o $@

%.vcd: %.vvp
	vvp $<

%.elf: %.c $(FIRMWARE_PATH)/sections.lds $(FIRMWARE_PATH)/start.s
	${GCC_PATH}/${GCC_PREFIX}-gcc -march=rv32imc -mabi=ilp32 -Wl,-Bstatic,-T,$(FIRMWARE_PATH)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(FIRMWARE_PATH)/start.s $<

%.hex: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@ 
	# to fix flash base address
	sed -i 's/@10000000/@00000000/g' $@

%.bin: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.log

.PHONY: clean hex all

