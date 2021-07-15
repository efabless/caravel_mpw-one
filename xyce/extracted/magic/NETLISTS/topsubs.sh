#! /bin/gawk -f
# Process a spice file. Output unique set of all subckt names DEFINED but not referenced. i.e. apparent topcells.
# Does not support .include or .lib.
#
# TODO: implicitly handle unfolding confinued lines. Currently requires input passed thru an unfold filter.
# TODO: ignore leading white space on lines

BEGIN { IGNORECASE=1 ; nbrerr = 0; ends = 0 ; snbr = 0 }

# remove leading,trailing whitespace or both
function ltrim(s) { sub(/^[ \t\r\n]+/, "", s); return s }
function rtrim(s) { sub(/[ \t\r\n]+$/, "", s); return s }
function trim(s) { return rtrim(ltrim(s)); }

# ignore 1st line of file
FNR==1 { next }

# mark locally defined subckt names
$1 == ".subckt" {
    if (locsubp[$2]) {
	print "ERROR-multiply-defined-SUBCKT:" $2 "-at-line-" FNR
    }
    locsubp[$2] = 1
    locsub[++l] = $2
}

# X lines: mark REFERENCED subckt names.
index($1, "x") == 1 {
    i = 1
    prev = ""
    subnm = ""
    while( ++i <= NF ) {
	if (prev != "" && index($i, "=") > 0) {
	    # at first prop=val previous field was instantiated subckt name 
	    subnm = prev
	    break
	}
	prev = $i
    }
    # if ended loop without reaching a prop=val, then last token was instantiated subckt name
    if (prev != "" && subnm == "") {
	subnm = prev
    }

    # if we found an instantiated (referenced) subckt name, store it
    if (subnm != "") {
	refsub[subnm] = 1
    }
    next
}

END {
    # foreach DEFINED subckt name: if was NOT-REFERENCED: output it.
    i=0
    size = length(locsub)
    while(++i <= size) {
	nm = locsub[i]
	if (! refsub[nm] ) {
	    print nm
	}
    }
    exit
}
