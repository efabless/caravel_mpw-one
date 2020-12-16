
set ::env(DESIGN_IN_DRC) [lindex $argv 0]
gds read $::env(DESIGN_IN_DRC).gds
set fout [open ./tmp/$::env(DESIGN_IN_DRC).drc w]
set oscale [cif scale out]
set cell_name $::env(DESIGN_IN_DRC)
magic::suspendall
puts stdout "\[INFO\]: Loading $::env(DESIGN_IN_DRC)\n"
flush stdout
load $::env(DESIGN_IN_DRC)
select top cell
drc euclidean on
drc style drc(full)
drc check
set drcresult [drc listall why]
set count 0
puts $fout "$::env(DESIGN_IN_DRC)"
puts $fout "----------------------------------------"
foreach {errtype coordlist} $drcresult {
    puts $fout $errtype
    puts $fout "----------------------------------------"
    foreach coord $coordlist {
        set bllx [expr {$oscale * [lindex $coord 0]}]
        set blly [expr {$oscale * [lindex $coord 1]}]
        set burx [expr {$oscale * [lindex $coord 2]}]
        set bury [expr {$oscale * [lindex $coord 3]}]
        set coords [format " %.3f %.3f %.3f %.3f" $bllx $blly $burx $bury]
        puts $fout "$coords"
        set count [expr {$count + 1} ]
    }
    puts $fout "----------------------------------------"
}

puts $fout "\[INFO\]: COUNT: $count"
puts $fout "\[INFO\]: Should be divided by 3 or 4"

puts $fout ""
close $fout

puts stdout "\[INFO\]: COUNT: $count"
puts stdout "\[INFO\]: Should be divided by 3 or 4"
puts stdout "\[INFO\]: DRC Checking DONE (./tmp/$::env(DESIGN_IN_DRC).drc)"
flush stdout

puts stdout "\[INFO\]: Saving mag view with DRC errors(./tmp/$::env(DESIGN_IN_DRC).drc.mag)"
# WARNING: changes the name of the cell; keep as last step
save ./tmp/$::env(DESIGN_IN_DRC).drc.drc.mag
puts stdout "\[INFO\]: Saved"
