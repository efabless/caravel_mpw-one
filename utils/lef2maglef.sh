#!/bin/bash

export PDK_ROOT=~/foss/pdks/open_pdks/sky130;
export MAGTYPE=mag ; 
export PDKPATH=$PDK_ROOT/sky130A ;
export MAGIC=magic


$MAGIC -rcfile $PDKPATH/libs.tech/magic/current/sky130A.magicrc -dnull -noconsole << EOX 
drc off
lef read $1.lef
load $1
save $1.lef.mag
#writeall force $1.lef.mag

		# copy GDS properties from the MAG view into the MAGLEF view
		set gds_properties [list]
		set fp [open $1.mag r]
			set mag_lines [split [read \$fp] "\n"]
			foreach line \$mag_lines {
				if { [string first "string GDS_" \$line] != -1 } {
					lappend gds_properties \$line
				}
			}
		close \$fp
		set fp [open $1.lef.mag r]
			set mag_lines [split [read \$fp] "\n"]
			set new_mag_lines [list]
			foreach line \$mag_lines {
				if { [string first "<< end >>" \$line] != -1 } {
					lappend new_mag_lines [join \$gds_properties "\n"]
				}
				lappend new_mag_lines \$line
			}
		close \$fp
		set fp [open $1.lef.mag w]
			puts \$fp [join \$new_mag_lines "\n"]
		close \$fp


quit
EOX

mv -f $1.lef.mag ../maglef/$1.mag
rm -f $1.lef
