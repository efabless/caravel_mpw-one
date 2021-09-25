 
 
 
$SAK/bin/hspice2ngspice.sh chip_io.cdl  chip_io.cdl.NG
$SAK/bin/subsnoempty.sh < chip_io.cdl.NG.unfolded > chip_io.cdl.NG.unfolded.no.empty.subckt
$SAK/bin/spiUniquify < chip_io.cdl.NG.unfolded `./topsubs.sh chip_io.cdl.NG.unfolded` > chip_io.cdl.NG.unfolded.no.duplicates




 mpirun -np 30 Xyce caravel_tb.spice
