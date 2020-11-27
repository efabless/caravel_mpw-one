#!/bin/sh -f

cd
mkdir skywater_pdk
cd skywater_pdk
git clone https://github.com/google/skywater-pdk
cd skywater-pdk
git submodule init libraries/sky130_fd_io/latest
git submodule init libraries/sky130_fd_pr/latest
#git submodule init libraries/sky130_fd_sc_hd/latest
#git submodule init libraries/sky130_fd_sc_hdll/latest
#git submodule init libraries/sky130_fd_sc_hs/latest
#git submodule init libraries/sky130_fd_sc_ms/latest
#git submodule init libraries/sky130_fd_sc_ls/latest
#git submodule init libraries/sky130_fd_sc_lp/latest
#git submodule init libraries/sky130_fd_sc_hvl/latest
git submodule update
make timing 
cd ~/skywater_pdk/
git clone git://opencircuitdesign.com/open_pdks
cd open_pdks
git checkout open_pdks-1.0
mkdir -p $HOME/skywater_pdk/pdk/skywater130
./configure --with-sky130-source=$HOME/skywater_pdk/skywater-pdk --with-sky130-local-path=$HOME/skywater_pdk/pdk/skywater130 --with-ef-style
cd sky130
make
make install
cd ~/skywater_pdk

echo "# Installing xschem sky130"
git clone https://github.com/StefanSchippers/xschem_sky130.git

echo "# copiando libreria"
cp ~/fulgor-opamp-sky130/xschem/sky130.lib ~/skywater_pdk/skywater-pdk/libraries/sky130_fd_pr/latest/models/corners/
#echo "# Installing sample designs"
#mkdir samples
#cd samples
#git clone https://github.com/bluecmd/learn-sky130.git
#git clone https://github.com/westonb/sky130-analog.git
#git clone https://github.com/yrrapt/amsat_txrx_ic.git
#git clone https://github.com/diadatp/sky130_rf_tools.git
#git clone https://github.com/pepijndevos/sky130-experiments.git
#git clone https://github.com/efabless/caravel.git
