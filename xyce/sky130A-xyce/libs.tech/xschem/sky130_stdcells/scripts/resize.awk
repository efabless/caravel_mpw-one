#!/usr/bin/gawk -f



FNR == 1 {
    if (_filename_ != "")
        endfile(_filename_)
    _filename_ = FILENAME
    #print "processing: " FILENAME >"/dev/stderr"
    beginfile(FILENAME)
}

END  { endfile(_filename_) }

###### begin user code ########################

BEGIN{
}

# T {CLK_N} -125 -54 0 0 0.2 0.2 {}
# B 5 -152.5 -32.5 -147.5 -27.5 {name=D dir=in }
# L 4 -150 -30 -130 -30 {}

{
  if($1 == "T") {
    a = $3;  $3 = (a < -96) ? a+60 : (a > 96) ? a-60 : a
  }
  if($1 == "B" || $1 == "L") {
    a = $3;  $3 = (a < -96) ? a+60 : (a > 96) ? a-60 : a
    a = $5;  $5 = (a < -96) ? a+60 : (a > 96) ? a-60 : a
  }
  found = 1
}

###### end  user code  ########################


{
 __a[__lines++] = $0 
}

function beginfile(f)
{
 __lines=0
 found=0
}

function endfile(f,   i)
{
 if(found)  {
   print "patching: " f >"/dev/stderr"
   for(i=0;i<__lines;i++)
   {
    print __a[i] > f
   }
   close(f)
 }
} 

