#!/usr/bin/bash

for x in `ls caravel-extracted.spice`
do
./unfold $x > $x.unfolded
./spiUniquify $x.unfolded `./topsubs.sh $x.unfolded` > ${x%.spice}.xyce; 
\rm *unfolded
done
