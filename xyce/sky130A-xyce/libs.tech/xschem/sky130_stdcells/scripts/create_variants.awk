#!/usr/bin/awk -f


BEGIN {

  skywater_dir = "/home/schippes/skywater-pdk/sky130_fd_sc_hd/"
  xschem_dir="/home/schippes/.xschem/xschem_library/xschem_sky130/sky130_stdcells/"
  
  pipe = "ls " skywater_dir "cells/*/sky130_fd_sc_*__*_*.spice|sort" 

  # /home/schippes/skywater-pdk/sky130_fd_sc_hd/cells/sdlclkp/sky130_fd_sc_hd__sdlclkp_1.spice
  while( pipe | getline line) {
    cell = line; sub(/^.*sky130_fd_sc_hd__/,"", cell); sub(/\.spice$/, ".sym", cell)
    basename = cell; sub(/(_[0-9]+)?\.sym$/, "", basename)
    
    if(cell !~ /_[0-9]+\.sym/) size = "nosize"
    else {
      size = cell; sub(/^.*_/,"",size); sub(/\.sym$/,"", size)
      size +=0
    }
    size_arr[size] = 1
    cell_list[basename] = 1
    cell_list_size[basename,size]=1
  }
  close(pipe)

  print_all = 0
  for(i in cell_list) {
    first = 1
    for(j in size_arr) {
      if( (i,j) in cell_list_size) {
        
        if( j !="nosize" && !file_exists( xschem_dir i "_" j ".sym") ) {
          if(find_existing(i)) {
            create_variant(i, find_existing(i), j)
          }
        }
      }
    }
  }
}

# format="@name @@CLK @@D @@DE @VGND @VNB @VPB @VPWR @@Q @@Q_N @prefix\\\\edfxbp_1"
function create_variant(cell, existing_size, new_size,     srcfile, destfile)
{
  destfile = xschem_dir cell "_" new_size ".sym"
  srcfile = xschem_dir cell "_" existing_size ".sym"
  print "to be created: "destfile
  print "from: " srcfile

  while( getline  < srcfile ) {
    if($0 ~ /^ *format="/) {
      sub(/_[0-9]+"$/, "_" new_size "\"")
    }
    print $0 > destfile
  }
  close(srcfile)
  close(destfile)

}

function find_existing(cell,     file, i)
{
  for(i in size_arr) {
    file = xschem_dir cell "_" i ".sym"
    if(file_exists(file)) {
      return i
      break
    }
  }
  return ""
}

function file_exists(file,       tmp) {
  n=(getline tmp < file);
  if (n > 0) {
    #print "Found: " file;
    close(file)
    return 1;
  } else if (n == 0) {
    close(file)
    # print "Empty: " file;
    return 1;
  } else {
    # print "Error: " file;
    return 0;
  }
}
