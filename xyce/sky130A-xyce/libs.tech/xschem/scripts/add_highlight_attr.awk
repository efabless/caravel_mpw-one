#!/usr/bin/awk -f

# ...
# K {type=primitive
# format="@name @@A @@B @VGND @VNB @VPB @VPWR @@X @prefix\\\\or2_1"
# template="name=x1 VGND=VGND VNB=VNB VPB=VPB VPWR=VPWR prefix=sky130_fd_sc_hd__ "
# extra="VGND VNB VPB VPWR prefix"}
# ...
#
# ==> 
#
# ...
# K {type=primitive
# format="@name @@A @@B @VGND @VNB @VPB @VPWR @@X @prefix\\\\or2_1"
# template="name=x1 VGND=VGND VNB=VNB VPB=VPB VPWR=VPWR prefix=sky130_fd_sc_hd__ "
# extra="VGND VNB VPB VPWR prefix"
# highlight=true}
# ...
#

BEGIN{
  while("ls *.sym"|getline f) {
    lines = 0
    global_attr = 0
    while(getline < f) {

      if($0 ~/} *$/ && global_attr == 1) {
        global_attr = 0
        sub(/} *$/, "\nhighlight=true}")
      }
      if($0 ~/^K {/) global_attr = 1
      celltext[lines] = $0
      lines++
      print
    }
    close(f)

    for(i = 0 ; i < lines; i++) {
      $0 = celltext[i]
      print $0 > f
    }
    close(f)
  }
  close("ls *.sym")
}


