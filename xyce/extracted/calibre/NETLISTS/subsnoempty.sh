#! /bin/gawk -f
# Process a spice file. For back-to-back .subckt,.ends (possibly with comments
# in between) delete (do not output) the whole subckt...ends block.
# Does not support .include or .lib.
# TODO: implicitly handle unfolding confinued lines. Currently requires input passed thru an unfold filter.
#
#   subsnoemtpy.sh <in.spi >out.spi
# or:
#   subsnoemtpy.sh  in.spi >out.spi
#
# recommend input be unfold-ed as in:
#   unfold <in.spi | subsnoempty.sh >out.spi
#

BEGIN { IGNORECASE=1 }

# print but otherwise ignore 1st line of file
# FNR==1 { print $0 ; next }

# start subckt: remember .subckt line, start accumulating lines...
$1 == ".subckt" {
    if (accum > 0) {
	print "f: " FILENAME " line#" FNR ", ERROR: start a subckt before last subckt closed" >>"/dev/stderr"
	print sublines
    }
    sublines = $0
    accum=1
    noncomm=0
    next
}
# end subckt: if accumulation has any non-comment lines: output subckt block.
# ERROR if .ends while not accumulating: output line and continue.
$1 == ".ends" {
    if (accum == 0) {
	print "f: " FILENAME " line#" FNR ", ERROR: extra .ends without opening .subckt" >>"/dev/stderr"
        print $0
	next
    }
    sublines = sublines "\n" $0
    if (noncomm > 0) print sublines
    accum=0
    next
}
# not-accumulating, just print line 
accum==0 { print $0; next }

# accumulate lines, but count the non-comments (empty line not a non-comment)
accum==1 {
    sublines = sublines "\n" $0;
    if ( NF != 0 && index($1, "*") != 1 ) {
	noncomm++
    }
}

# still accumulating?: print'em. Should be error: .subckt without .ends.
END {
    if (accum > 0) {
	print "f: " FILENAME " line#" FNR ", ERROR: file ends without last subckt closed" >>"/dev/stderr"
	print sublines
    }
}
