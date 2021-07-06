#!/usr/bin/awk -f


BEGIN {

  skywater_dir = "/home/schippes/skywater-pdk/sky130_fd_sc_hd/"
  xschem_dir="/home/schippes/.xschem/xschem_library/xschem_sky130/sky130_stdcells/"
  
  pipe = "ls " xschem_dir "*.sym|sort" 
  # /home/schippes/skywater-pdk/sky130_fd_sc_hd/cells/sdlclkp/sky130_fd_sc_hd__sdlclkp_1.spice
  x = 0; y = 0
  while( pipe | getline line) {
    cell = line; sub(/^.*sky130_stdcells/, "sky130_stdcells", cell)
    print "C {" cell "} " x, y, 0, 0, "{}"
    x+=260
    if(x > 7000) { x=0; y+=240 } 
  }
  close(pipe)
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
