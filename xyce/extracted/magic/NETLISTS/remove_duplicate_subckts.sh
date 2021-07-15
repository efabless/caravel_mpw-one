#!/usr/bin/bash

for x in `ls sky130*.spice`
do
./unfold $x > $x.unfolded
./spiUniquify $x.unfolded `./topsubs.sh $x.unfolded` > ${x%.spice}.xyce; 
\rm *unfolded
done
