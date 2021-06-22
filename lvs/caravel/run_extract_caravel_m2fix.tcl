
set DESIGNS ~/foss/designs
set PROJECT_ROOT $DESIGNS/caravel.mpw-one-final-metal-fix
set PDK_ROOT ~/foss/pdks
drc off
crashbackups stop

# Load abstract versions of SRAM and I/O.  If not local, they
# need to be copied from the PDK library and saved with the
# suffix.


# All I/O pads need to be abstracted 

load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vccd_lvc_clamped2_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssd_lvc_clamped2_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vccd_lvc_clamped_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssd_lvc_clamped_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vdda_hvc_clamped_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssio_hvc_clamped_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vddio_hvc_clamped_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssa_hvc_clamped_pad
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_fd_io__top_gpiov2
load $PDK_ROOT/sky130A/libs.ref/sky130_fd_io/maglef/sky130_fd_io__top_xres4v2


# This one is only an abstract view 
load $PROJECT_ROOT/maglef/sram_1rw1r_32_256_8_sky130.mag

# These cells must be abstracted or else they won't extract right (due to split
# grounds or incompatible subcell abstract views, in the case of the SRAM)

load $PROJECT_ROOT/maglef/storage.mag
load $PROJECT_ROOT/maglef/gpio_control_block.mag
##load $PROJECT_ROOT/maglef/mgmt_protect.mag

# The following are probably okay not being abstracted?  Abstracting mgmt_core
# will greatly speed up everything.

load $PROJECT_ROOT/maglef/simple_por.mag
load $PROJECT_ROOT/maglef/mgmt_protect_hv.mag
load $PROJECT_ROOT/maglef/mgmt_core.mag
load $PROJECT_ROOT/maglef/digital_pll.mag
load $PROJECT_ROOT/maglef/user_project_wrapper.mag

# The following should not be abstracted as the m2 fix touches the level shifter
load $PROJECT_ROOT/mag/sky130_fd_sc_hvl__lsbufhv2lv_1_wrapped.mag -derefernce

# Ensure we have a valid edit cell
load test
box values 0 0 0 0

# Now read the caravel chip GDS
cif istyle sky130(vendor)
gds noduplicates true
gds read $PROJECT_ROOT/gds/caravel.gds

# GDS has an empty user project.  This will get optimized out of the output
# SPICE netlist unless it is declared abstract
#load user_project_wrapper
#property LEFview true

load caravel.mag -dereference
select top cell
expand
extract do local
extract all
ext2spice lvs
ext2spice -o caravel.mixed-abstraction.lay.spice

