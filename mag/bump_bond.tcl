namespace path {::tcl::mathop ::tcl::mathfunc}

# Bump bond is a circle (approximated by a 20-sided polygon) of
# diameter nominally 250um

set rbump 125
set coords []
for {set i 0} {$i < 20} {incr i} {
    set angle [* $i 18]
    set arad [/ [* 3.1415926 $angle] 180.0]
    lappend coords [int [* $rbump [cos $arad]]]um
    lappend coords [int [* $rbump [sin $arad]]]um
}

eval [subst {polygon metalrdl $coords}]
