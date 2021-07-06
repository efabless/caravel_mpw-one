#!/usr/bin/awk -f

# ...
# B 5 -62.5 -22.5 -57.5 -17.5 {name=A dir=in }
# B 5 -62.5 17.5 -57.5 22.5 {name=B dir=in }
# B 5 57.5 -2.5 62.5 2.5 {name=X dir=out }
# ...
#
# ==> 
#
# ...
# B 5 -62.5 -22.5 -57.5 -17.5 {name=A dir=in propagate_to=2 }
# B 5 -62.5 17.5 -57.5 22.5 {name=B dir=in propagate_to=2 }
# B 5 57.5 -2.5 62.5 2.5 {name=X dir=out }
# ...


BEGIN{
  outpin["X"] = outpin["Y"] = outpin["Z"] = 1
  while("ls *.sym"|getline f) {
    lines = 0
    pinnumber = 0
    propagate_to = -1
    delete celltext
    while(getline < f) {
      if($0 ~/^B 5.*name=.*dir=/) {
        pinname = get_pinname($0)
        # print f, pinname
        if(pinname in outpin) propagate_to = pinnumber
        pinnumber++
      }
      celltext[lines] = $0
      lines++
    }
    close(f)

    for(i = 0 ; i < lines; i++) {
      $0 = celltext[i]
      if($0 ~/^B 5.*name=.*dir=/) {
        pinname = get_pinname($0)
        if(!(pinname in outpin) && $0 !~/propagate_to/ && propagate_to >= 0) {
          sub(/ *} *$/, " propagate_to=" propagate_to " }")
        }
      }
      print $0 > f
    }
    close(f)
  }
  close("ls *.sym")
}

function get_pinname(pinname)
{
  sub(/^.*name *= */,"", pinname)
  sub(/ +.*/,"", pinname)
  return pinname
}

