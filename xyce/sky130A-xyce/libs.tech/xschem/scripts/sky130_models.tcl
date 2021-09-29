

# /home/schippes/projects/foundry/skywater-pdk/libraries/sky130_fd_sc_hd/latest
proc sky130_models {} {
  global SKYWATER_STDCELLS
  set l {}
  if {![info exists SKYWATER_STDCELLS]} {
    puts "ERROR: SKYWATER_STDCELLS TCL variable undefined, please set in xschemrc and restart xschem"
    return {***** ERROR: missing TCL var SKYWATER_STDCELLS}
  }
  foreach  i [xschem symbols] {
    if { [regexp {stdcells} $i] }  {
      set cell [lindex ${i} 1]
      regsub {/latest *$} $SKYWATER_STDCELLS {} prefix
      regsub {.*/} $prefix {} prefix
      append prefix __
      regsub {.*/} $cell {} cell
      regsub {\.sym} $cell {.spice} spice
      regsub {_[^_]+\.sym} $cell {} dir
      append l .include\ $SKYWATER_STDCELLS/cells/$dir/$prefix$spice\n
    }
  }
  return $l 
}

