#!/bin/sh
#
# Remove any prefixed layouts if they were created before and not removed
#
rm -f pk_*.mag
rm -f 9k_*.mag
#
# Load top-level extraction of caravel with black-boxed SRAM and I/O cells
#
magic -dnull -noconsole -rcfile /usr/share/pdk/sky130A/libs.tech/magic/sky130A.magicrc << EOF
drc off
crashbackups stop

# Load abstract versions of SRAM and I/O.  If not local, they
# need to be copied from the PDK library and saved with the
# suffix.

# This one is only an abstract view 
load sram_1rw1r_32_256_8_sky130

# Create the prefixed versions (why do the prefixes keep growing??)
save pk_pk_pk_sram_1rw1r_32_256_8_sky130

# All I/O pads need to be abstracted and prefixed
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vccd_lvc_clamped2_pad
save 9k_sky130_ef_io__vccd_lvc_clamped2_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssd_lvc_clamped2_pad
save 9k_sky130_ef_io__vssd_lvc_clamped2_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vccd_lvc_clamped_pad
save 9k_sky130_ef_io__vccd_lvc_clamped_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssd_lvc_clamped_pad
save 9k_sky130_ef_io__vssd_lvc_clamped_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vdda_hvc_clamped_pad
save 9k_sky130_ef_io__vdda_hvc_clamped_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssio_hvc_clamped_pad
save 9k_sky130_ef_io__vssio_hvc_clamped_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vddio_hvc_clamped_pad
save 9k_sky130_ef_io__vddio_hvc_clamped_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_ef_io__vssa_hvc_clamped_pad
save 9k_sky130_ef_io__vssa_hvc_clamped_pad
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_fd_io__top_gpiov2
save 9k_sky130_fd_io__top_gpiov2
load /usr/share/pdk/sky130A/libs.ref/sky130_fd_io/maglef/sky130_fd_io__top_xres4v2
save 9k_sky130_fd_io__top_xres4v2

# These cells must be abstracted or else they won't extract right (due to split
# grounds or incompatible subcell abstract views, in the case of the SRAM)

load ../maglef/storage.mag
load ../maglef/gpio_control_block.mag
# load ../maglef/mgmt_protect.mag

# The following are probably okay not being abstracted?  Abstracting mgmt_core
# will greatly speed up everything.
load ../maglef/simple_por.mag
load ../maglef/mgmt_protect_hv.mag
load ../maglef/mgmt_core.mag
load ../maglef/digital_pll.mag

# Ensure we have a valid edit cell
load test
box values 0 0 0 0

# Now read the caravel chip GDS
cif istyle sky130(vendor)
gds noduplicates true
gds read ../gds/caravel.gds

# GDS has an empty user project.  This will get optimized out of the output
# SPICE netlist unless it is declared abstract
load user_project_wrapper
property LEFview true

load caravel
select top cell
expand
extract do local
extract all
ext2spice lvs
ext2spice
quit -noprompt

EOF
