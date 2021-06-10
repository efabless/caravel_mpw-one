#!/ef/efabless/lib/vcd2ngspice-d_source/bin/python3
# rb@ef: was !/usr/bin/env python

# sdaau 2011; based mostly on
# http://stackoverflow.com/questions/4140884/pyparsing-forward-and-recursion

# call with:
# python2.7 vcd2ngspice-d_source.py -i FILENAME.vcd 2>/dev/null > d_source.text
# python3.2 vcd2ngspice-d_source.py -i FILENAME.vcd 2>/dev/null > d_source.text

from pprint import pprint, pformat
from pyparsing import Word, alphas, Suppress, Literal, Group, Forward, ZeroOrMore, SkipTo, StringEnd, Each, Optional, OneOrMore, LineEnd, alphanums, printables, Combine, nums
import sys, os
import getopt


## globals

# this script name, as passed by the command line call
scriptcallpath = sys.argv[0]
# the input vcd file path string
inputfile=None
# input file handle
inputfh=None
# header as parsed list
VCDheader_pl=None
# how many lines of text in VCD file
VCDfile_linecount=0
# how many lines of text in VCDheader
VCDheader_linecount=0
# how many lines of text in VCDdata
VCDdata_linecount=0
# collection of all reg/wires (all vars) in VCD file (listed in header)
VCD_allvars=[]
# collection of all data in VCD file (parsed) as Python list items
VCD_alldata=[]


SCOPE, VAR, UPSCOPE, END, ENDDEFINITIONS = map(Suppress,
                                "$scope $var $upscope $end $enddefinitions".split())

# these in Literal so they show as "indexes"
DATE, VERSION, TIMESCALE, MODULE, WIRE, REG = map(Literal, "$date $version $timescale module wire reg".split())

# note [1]
DATE.setParseAction(lambda t : "date")
VERSION.setParseAction(lambda t : "version")
TIMESCALE.setParseAction(lambda t : "timescale")

scope_header = Group(SCOPE + MODULE + Word(printables) + END)
wordortwonotend = ( OneOrMore( ~END + Word(printables)) )
wordortwonotend.setParseAction(lambda t : ' '.join(t)) # to put possible multi words in the same string (field) [for signal names with spaces]
wire_map = Group(VAR + WIRE + Word(alphanums) + Word(printables) + wordortwonotend + END)
reg_map = Group(VAR + REG + Word(alphanums) + Word(printables) + wordortwonotend + END)
var_map = (wire_map | reg_map)
scope_footer = (UPSCOPE + END)
enddefs_footer = (ENDDEFINITIONS + END)
#~ wire_map.setDebug()

# note [3]
var_map.setParseAction(lambda t : VCD_allvars.append(t.asList()[0]))

# enveloping Suppress/SkipTo removes the '$end' from match results
date_header = Group( DATE + SkipTo( END ) + Suppress(SkipTo( LineEnd() )) )
version_header = Group( VERSION + SkipTo( END ) + Suppress(SkipTo( LineEnd() )) )
timescale_header = Group( TIMESCALE + SkipTo( END ) + Suppress(SkipTo( LineEnd() )) )

# note [2] - NOTE recursion here!
scope = Forward()
scope << Group(scope_header + ZeroOrMore( (var_map | scope) ) + scope_footer) # with an extra group

vcdpreamble = ( Each([Optional(date_header), Optional(version_header), Optional(timescale_header)]) )

vcdheader = Forward()
vcdheader << ( vcdpreamble +  ZeroOrMore( (var_map | scope) ) + enddefs_footer)

# timescale label "10ns"
timesclabel=Word(nums)+Word(alphas)
# dict for timescale label exponents
# rb@ef: add whole second 's':
tbase_d = {'fs': 1e-15, 'ps': 1e-12, 'ns': 1e-9, 's': 1.0}
# dicts for converting singular VCD values:
# dict for ngspice `d_source` values:
# values: 12-State value (0s, 1s, Us, 0r, 1r, Ur, 0z, 1z, Uz, 0u, 1u, Uu).
# https://sourceforge.net/projects/ngspice/forums/forum/133842/topic/4835459
vcd2g_sing_d = {'0':'0s', '1':'1s', 'Z':'Uz', 'x':'Uu'}
# dict for ngspice `filesource` values:
# use 0.0 to 1.0 for LO/HI - then can easily scale them in filesource
# (amploffset=0.0; amplscale=5.0 => 0 to 5)
# thus 0.5 will be Z - for x, choose -0.1
vcd2g_sing_f = {'0':'0.0', '1':'1.0', 'Z':'0.5', 'x':'-0.1'}
# choice of format: "d", "f"
outformat=None


## functions

def usage():
  # global scriptcallpath # no need for global if we just read
  logso("""vcd2ngspice-d_source.py v.2011-11-29

Converts vcd data to ngspice's `d_source` or `filesource` data formats

Usage:
  python2.7/3.2 """ + scriptcallpath + """ [-h] [-f] -i/--input-file=filename 2>/dev/null > df_source.text

  [-f/--fsformat] - choose `filesource` data format (without it, default is `d_source`)

* Stderr is used for messages (redirect to /dev/null to suppress)
* Stdout is used for converted file output (redirect to file to save)
""")

def logse(instr, eol="\n"): # to stderr
  sys.stderr.write(instr + eol)
  sys.stderr.flush()

def logso(instr, eol="\n"): # to stderr
  sys.stdout.write(instr + eol)
  sys.stdout.flush()

def main():
  global scriptcallpath, inputfile, inputfh
  global VCDfile_linecount
  global outformat
  try:
    opts, args = getopt.getopt(sys.argv[1:], "hi:f", ["help", "input-file=", "fsformat"])
  except getopt.GetoptError as err: # supported by 2.6 syntax by backport
    # print help information and exit:
    logse(str(err)) # will print something like "option -a not recognized"
    usage()
    sys.exit(2)

  # default output file format is `d_source`
  outformat = "d"
  for o, a in opts:
    if o in ("-h", "--help"):
      usage()
      sys.exit()
    elif o in ("-i", "--input-file"):
      inputfile = a
    elif o in ("-f", "--fsformat"):
      outformat = "f"
    else:
      assert False, "unhandled option"

  if (inputfile == None):
    usage()
    sys.exit()


  if os.path.isfile(inputfile):
    try:
      # this will open file - if all goes well, we'll have
      # the number of lines in file returned (and file closed)
      VCDfile_linecount = bufcount(inputfile)
    except IOError as e:
      logse('Problems with ' + inputfile + '.')
      logse("({})".format(e))
      logse('Exiting.')
      sys.exit()
  else:
    logse('Not found ' + inputfile + '.')
    logse('Exiting.')
    sys.exit()

  # since at this point, file should exist, and we should have read
  # number of lines in it, just open it directly here
  inputfh = open(inputfile)

  logse("Processing " + inputfile + "...")

  getVCDHeader()
  getVCDdata()
  generateOutput()
#
# END main()
#



def getVCDHeader():
  global VCDheader_pl, VCDheader_linecount
  logse("getVCDHeader: PROCESSING ...")
  VCDheader_l = []
  inHeader = True
  VCDheader_linecount = 0
  for line in inputfh:
    VCDheader_linecount += 1
    line = line.rstrip() # chomp (all) the whitespace at end
    if (not(not(line))): # if not empty string
      if inHeader:
        VCDheader_l.append(line) # append first (include the enddefs line)
        if line.startswith("$enddefinitions"):
          inHeader = False
          break
  if inHeader:    # we never reached end of header, alert problem
    logse("Problem with file tmpe_l+- cannot find end of header:")
    logse("\n".join(VCDheader_l))
    logse('Exiting.')
    sys.exit()

  VCDheader_s = "\n".join(VCDheader_l)
  #~ print(VCDheader_s)
  res = vcdheader.parseString(VCDheader_s)
  #~ pprint(res.dump()) # no .asList(), looks like string only
  VCDheader_pl = res.asList()
  logse(pformat(VCDheader_pl) + "\n") # pprint(VCDheader_pl)
  #~ logse(pformat(VCD_allvars) + "\n")
#
# END getVCDHeader()
#


def getVCDdata():
  global VCDdata_linecount, VCD_alldata
  # note [4]
  logse("getVCDdata: PROCESSING ...")

  VCDdata_linecount = 0
  VCD_alldata = []                # the global array (reset)
  dumpvars_l = []                 # arrays of dumpvars/dumpoffs
  dumpoffs_l = []
  in_dumpvars = got_dumpvars = 0  # handling of dumpvars/dumpoffs
  in_dumpoffs = got_dumpoffs = 0
  tmpe_l = []                     # temporary time/values entry
  tmpL_l = []                     # temporary list of time/vals entries
  for line in inputfh:
    VCDdata_linecount += 1
    if line.startswith("$dumpvars"):
      logse("Got $dumpvars: " + str(VCDdata_linecount + VCDheader_linecount)+"\n")
      got_dumpvars += 1
      in_dumpvars = 1
    elif line.startswith("$dumpoff"):
      logse("Got $dumpoff: " + str(VCDdata_linecount + VCDheader_linecount)+"\n")
      got_dumpoffs += 1
      in_dumpoffs = 1
    elif line.startswith("$end"):
      logse("Got $end: " + str(VCDdata_linecount + VCDheader_linecount)+"\n")
      logse(" inend-in  " + str(VCDdata_linecount) + " ( +" + str(VCDheader_linecount) + ") lines; dumpvars: " + str(len(dumpvars_l)) + " ; dumpoffs: " + str(len(dumpoffs_l)) + " ; tmpL: " + str(len(tmpL_l)) + " items")
      if (in_dumpvars == 1):
        if not(tmpe_l == []): # not tmpL_l!!! use tmpe_l
          dumpvars_l.append(tmpe_l)
          VCD_alldata.append(tmpe_l)
        tmpe_l = []
        in_dumpvars = 0
      elif (in_dumpoffs == 1):
        if not(tmpe_l == []):
          dumpoffs_l.append(tmpe_l)
          VCD_alldata.append(tmpe_l)
        tmpe_l = []
        in_dumpoffs = 0
      else:
        logse("Got a loose $end in data .... (line)" + (VCDdata_linecount + VCDheader_linecount))
      logse(" inend-out " + str(VCDdata_linecount) + " ( +" + str(VCDheader_linecount) + ") lines; dumpvars: " + str(len(dumpvars_l)) + " ; dumpoffs: " + str(len(dumpoffs_l)) + " ; tmpL: " + str(len(tmpL_l)) + " items")
    elif line.startswith("#"):    # 'tis a time marker - paers and pushe!
      # here we switch - log previous
      perc = "%2.2f%% " % (100*(VCDdata_linecount + VCDheader_linecount) / VCDfile_linecount)
      logse(perc + str(VCDdata_linecount) + " " + str(tmpe_l)[:30], eol="\r")

      tmpt = int(line[1:].rstrip()) # substring; clean whitespace; to int
      if not(tmpe_l == []):
        tmpL_l.append(tmpe_l)
        VCD_alldata.append(tmpe_l)
      tmpe_l = []                   # start a new element
      tmpe_l.append(tmpt)           # pushe!
    else:                         # we have a "value" line
      # value lines:
      # either two char: "0#" - first char val:(0,1,Z), second char id
      # or "b11110110 $" - space separated: first word value, second char id
      line = line.rstrip()
      tmpval = tmpid = ""
      if ( len(line) == 2 ):    # here len() - string length (num chars)
        tmpval = line[0:1]
        tmpid  = line[1:2]
      else:
        tmpa = line.split(' ');
        if ( len(tmpa) == 2 ):  # here len() - list length (num items)
          tmpval = tmpa[0]
          tmpid  = tmpa[1]
      if ( (tmpval=="") or (tmpid=="") ):
        logse("Cannot parse line " + (VCDdata_linecount + VCDheader_linecount))
      else:
        tmpe_l.append([tmpid, tmpval])
  #
  # done parsing;
  #~ pprint(tmpL_l) # takes a LOOONG time for big array!
  #
  def tformat(ins):
    #~ return pformat(ins) # multiline
    return str(ins) # single line

  logse("Processed " + str(VCDdata_linecount) + " ( +" + str(VCDheader_linecount) + ") lines; dumpvars: " + str(len(dumpvars_l)) + " ; dumpoffs: " + str(len(dumpoffs_l)) + " ; tmpL: " + str(len(tmpL_l)) + " ; VCD_alldata: " + str(len(VCD_alldata)) + " items")
  logse("dumpvars:\n" + tformat(dumpvars_l))
  logse("dumpoffs:\n" + tformat(dumpoffs_l))
  try: logse("tmpL_l[0]:\n" + tformat(tmpL_l[0]))
  except: logse("tmpL_l[0]: TROUBLE: " + str(sys.exc_info()[1]))
  try: logse("tmpL_l[len-1]:\n" + tformat(tmpL_l[len(tmpL_l)-1]))
  except: logse("tmpL_l[len-1]: TROUBLE: " + str(sys.exc_info()[1]))

  # note [5]
  try: logse("VCD_alldata[0]:\n" + tformat(VCD_alldata[0]))
  except: logse("VCD_alldata[0]: TROUBLE: " + str(sys.exc_info()[1]))
  try: logse("VCD_alldata[1]:\n" + tformat(VCD_alldata[1]))
  except: logse("VCD_alldata[1]: TROUBLE: " + str(sys.exc_info()[1]))
  try: logse("VCD_alldata[len-2]:\n" + tformat(VCD_alldata[len(VCD_alldata)-2]))
  except: logse("VCD_alldata[len-2]: TROUBLE: " + str(sys.exc_info()[1]))
  try: logse("VCD_alldata[len-1]:\n" + tformat(VCD_alldata[len(VCD_alldata)-1]))
  except: logse("VCD_alldata[len-1]: TROUBLE: " + str(sys.exc_info()[1]))


  logse("\n---------- DONE READ & PARSE OF INPUT VCD ------ \n\n")
#
# END getVCDdata()
#


def generateOutput():
  logse("\n---------- GENERATING OUTPUT ------ \n\n")
  # note [6]
  tbss=""
  for ix in VCDheader_pl:
    if ix[0] == "timescale":
      tbss = ix[1].rstrip() # chomp too
  # we need to parse "1ps"; "1ns" or "10fs" - use pyparsing
  tlab = timesclabel.parseString(tbss)
  timescl_base = int(tlab[0])
  timescl_exp = tbase_d[tlab[1]]
  timescl_num = timescl_base*timescl_exp;
  # assuming the timescale is expressed in terms of 1;
  # and the timesteps (timescl_base) are integers;
  # then for the d_source file we can simply append
  # string representation of the exponent (timescl_exps):
  timescl_exps = str(timescl_exp)
  timescl_exps = timescl_exps[timescl_exps.find('e'):]
  logse(tbss + " timescl_base: " + str(timescl_base) + " ; timescl_exp: " + timescl_exps + " / " + str(timescl_exp) + " ; tot: " + str() )
  # create temp master object dict
  curVals = {}
  tmpid1 = []     # for comment for ngspice d_source file
  tmpid2 = []
  for ix in VCD_allvars:
    curVals[ix[2]] = "0"
    #~ tmpid1.append(ix[2])
    #~ tmpid2.append(ix[3])
  logse("curVals: " + str(curVals))
  # sorted curVals for tmpids
  for ikey in sorted(curVals):
    tmpid1.append(ikey)
    # (damn this is stupid: have to re-iterate just to get predictable order from dict)
    for ix in VCD_allvars:
      if ix[2] == ikey:
        tmpid2.append(ix[3])
        break

  # check the data format here;
  outformatdict=None
  commentchar=None
  if (outformat=="f"):
    outformatdict=vcd2g_sing_f
    commentchar="#"
    logse("Outputting in `filesource` format")
  else: # default
    outformatdict=vcd2g_sing_d
    commentchar="*"
    logse("Outputting in `d_source` format")

  # start outputting file
  logso(commentchar+" " + scriptcallpath + ": conversion of " + inputfile)
  logso(commentchar+" time\t" +  "\t".join(tmpid1))
  logso(commentchar+" time\t" +  "\t".join(tmpid2))

  for item in VCD_alldata:
    ttime = item[0]
    tvals = item[1:] # all subsequent
    # note: duplicate ids in item (from dumpoffs, maybe) will be overwritten!
    for ival in tvals:
      convok = 0
      #~ logse(str(ival) + " . " + str(item)) # debug
      if (len(ival[1]) == 1):
        try:
          curVals[ival[0]] = outformatdict[ival[1]] # "Uz"
          convok = 1
        except:
          convok = 0
      if (convok == 0): # just set the value in this case - but ngspice will fail on it!
        curVals[ival[0]] = ival[1]
    # done setting curVals for this item - output:
    ttimes = str(ttime) + timescl_exps;
    tstrvals=[]
    # for ikey in curVals: # hopefully, the ordering won't change with this? Well, it does?!
    for ikey in sorted(curVals): #
      tstrvals.append(curVals[ikey])
    logso(ttimes + "\t" + "\t".join(tstrvals))

  logse("\n---------- DONE GENERATING OUTPUT ---- \n\n")
#
# END generateOutput()
#




#~ http://stackoverflow.com/questions/845058/how-to-get-line-count-cheaply-in-python
def bufcount(filename):
  f = open(filename)
  lines = 0
  buf_size = 1024 * 1024
  read_f = f.read # loop optimization

  buf = read_f(buf_size)
  while buf:
    lines += buf.count('\n')
    buf = read_f(buf_size)

  f.close()
  return lines
#
# END bufcount()
#



# to avoid forward declare of functions problems;
# have a main function, and this at end.
if __name__ == "__main__":
  #~ main() # graceful shutdown, instead:
  try:
      retval = main()
  except KeyboardInterrupt:
      logse("\nCtrl-C pressed; exiting ... ")
      sys.exit(1)





## ------------------------------------

# notes:

# python; "usual python" parser
# http://paddy3118.blogspot.com/2008/03/writing-vcd-to-toggle-count-generator.html

# python, pyparsing (not complete, but has good explanation)
# http://stackoverflow.com/questions/4140884/pyparsing-forward-and-recursion
# http://pyparsing.wikispaces.com/ - http://packages.python.org/pyparsing/ - only docs (or a book)
# sudo apt-get install python-pyparsing # 1.5.2-2;
# https://launchpad.net/ubuntu/+source/pyparsing/1.5.2-2: "use globbing to remove pyparsing_py3.py - Closes: #571505"
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=571505
# but also in new: "IMPORTANT API CHANGE for PYTHON 3 USERS! - This release also clears up the import discrepancy between the two versions of Python, that was introduced in version 1.5.2 - now regardless of Python version, users can just write import pyparsing in their code, there is no longer a separate pyparsing_py3 module."
# sudo apt-get remove --purge python-pyparsing
# # sudo apt-get install python-setuptools # for easy_install; only 2.7
# # pypi-install in python-stdeb; 16 MB
# curl -O http://python-distribute.org/distribute_setup.py ;
# sudo python2.7 distribute_setup.py # Installing easy_install-2.7 script to /usr/local/bin
# sudo python3.2 distribute_setup.py # Installing easy_install-3.2 script to /usr/local/bin
#~ sudo easy_install-2.7 pyparsing
#~ sudo easy_install-3.2 pyparsing

# py 2 / 3 : "common import idiom is to try the new name first, then fall back to the old name imported as the new name."


#~ Vcdparser/Vtracer "Note: Vcdparser subproject is not functional any more !!!" (also bit strange to work in)
#~ http://vtracer.sourceforge.net/vtracer_spec_5.html#SEC26

# [http://groups.google.com/group/comp.lang.verilog/browse_thread/thread/cde8166b761b1c1d?fwc=2 VCD parser - comp.lang.verilog | Google Groups] - just a question...

# http://docs.python.org/dev/howto/pyporting.html#python-2-3-compatible-source ... http://docs.pythonsprints.com/python3_porting/py-porting.html


# note [1]
# names could be "pwmcount[7:0]" or "pwmcount [7]"; use Combine (no, setParseAction) to merge them
# a "cheap" way to return/write "word" instead of "$word" in the results (without parsing - though could be replaced with a single function that removes initial '$' sign)

# note [2]
# "Forward declaration of an expression to be defined later - used for recursive grammars, such as algebraic infix notation. When the expression is known, it is assigned to the Forward variable using the '<<' operator.... It is recommended that you explicitly group the values inserted into the Forward:"
# NOTE recursion here!

# note [3]
# this will printout and not interfere otherwise (doesn't return a string)
#~ var_map.setParseAction(lambda t : sys.stderr.write(str(t)))
# t is of type pyparsing.ParseResults - need to get actual result asList[0]
# calling like this doesn't interfere with rest of code

  # note [4]
  # after header is parsed (after '$enddefinitions')
  # there may be '$dumpvars'/'$end' - if so, there will be
  # also '$dumpoff'/'$end' ? not always:
  # some: '$dumpvars'/'$end'; some: '$dumpvars'/'$end' + '$dumpoff'/'$end'; some '$dumpvars' only, without terminating end (gtkwave single channel export); ghdl exports no '$dumpvars'
  # if terminating end, then signals/values are listed inside!
  # the first line with '#NUM' will be the starting time..
  # NOTE: 'for line in inputfh' (file open) continues from where it left off last; if header was properly parsed (it broke correctly), it should be next line after $enddefinitions
  # (for file open, we need file close/reopen to "reset the stream"; or seek?
  # .. but for .tell(): "IOError: telling position disabled by next() call"!!)
  #~ print("getVCDdata: Continuing from " + inputfh.tell() + " bytes ..." )
  # go line-by-line (could be big file); pyparsing would need a string in memory!
  # however, we still need an array in memory (tmpL_l), since we're going to resample... (hopefully int(timestamp) will save some memory )


  # note [5]
  # here we should in principle check all timestamps,
  # and create a properly sorted array from tmpL_l, dumpvars_l and dumpoffs_l
  # however; assuming that the input file will be sorted;
  #  will simply append items to a global list in sync with when these
  #  temporary ones are assigned (cheaper codingwise, but will cost
  #  some memory + possibly some unandled cases)
  # note also, the getVCDdata parsing algorithm may add
  #  duplicate ids for dumpoffs!!

  # note [6]
  # here we have VCD_alldata; however, VCD saves only differences;
  # ngspice d_source format does not need equidistant time samples;
  # however it needs all values for all channels specified in columns!
  # we'll have a master "current values" object (dict); we'll update it respectively; and we'll render it's state
  # however, we have to take care of the timebase too...
  # values: 12-State value (0s, 1s, Us, 0r, 1r, Ur, 0z, 1z, Uz, 0u, 1u, Uu).



# failed header parses:
#~ > #~ scope_header = Group(SCOPE + MODULE + Word(alphas) + END)
#~ > scope_header = Group(SCOPE + MODULE + Word(printables) + END)
#~ > #~ wire_map = Group(VAR + WIRE + Word(alphanums) + Word(printables) + Word(printables) + END)
#~ > #~ wire_map = Group(VAR + WIRE + Word(alphanums) + Word(printables) + Combine(Word(printables) + Optional(Word(printables))) + END)
#~ > #~ wordortwo = ( Word(printables) + Optional(Word(printables)) + END )
#~ > #~ wordortwo = ( ( (Word(printables)) | (Word(printables) + Optional(Word(printables))) ) + END ) # NOT OK!!!!! must insert END separately!
#~ > #~ wordortwo = ( (Word(printables) + END) | ( Word(printables) + Optional(Word(printables)) + END ) ) # ok
#~ > # pyparsing.wikispaces.com/message/view/home/45375244 "If you write "OneOrMore(Word(printables))" in your grammar, there is a good chance that one expression will read the entire rest of your input string."
#~ > wordortwonotend = ( OneOrMore( ~END + Word(printables)) )
#~ > wordortwonotend.setParseAction(lambda t : ' '.join(t)) # to put possible multi words in the same string (field)
#~ > wire_map = Group(VAR + WIRE + Word(alphanums) + Word(printables) + wordortwonotend + END)
#~ > #~ reg_map = Group(VAR + REG + Word(alphanums) + Word(printables) + OneOrMore(Word(printables)) + END)
#~ > reg_map = Group(VAR + REG + Word(alphanums) + Word(printables) + wordortwonotend + END)
#~ > var_map = (wire_map | reg_map)
#~ > scope_footer = (UPSCOPE + END)
#~ > enddefs_footer = (ENDDEFINITIONS + END)
#~ > #~ wire_map.setDebug()
#~ > #~ scope_footer.setDebug()
#~ > #~ WIRE.setDebug()
#~ > #~ wordortwonotend.setDebug()
#~ >
#~ > #~ date_header = Group( DATE + SkipTo( END | StringEnd()) )
#~ > #~ date_header = Group( DATE + SkipTo( END ) )
#~ > # enveloping Suppress/SkipTo removes the '$end' from match results
#~ > date_header = Group( DATE + SkipTo( END ) + Suppress(SkipTo( LineEnd() )) )
#~ > version_header = Group( VERSION + SkipTo( END ) + Suppress(SkipTo( LineEnd() )) )
#~ > timescale_header = Group( TIMESCALE + SkipTo( END ) + Suppress(SkipTo( LineEnd() )) )
#~ >
#~ > # "Forward declaration of an expression to be defined later - used for recursive grammars, such as algebraic infix notation. When the expression is known, it is assigned to the Forward variable using the '<<' operator.... It is recommended that you explicitly group the values inserted into the Forward:"
#~ > # NOTE recursion here!
#~ > scope = Forward()
#~ > #~ scope << (scope_header + ZeroOrMore( (var_map | scope) ) + scope_footer)
#~ > #~ scope << (scope_header + ZeroOrMore( Each([ Optional(wire_map), Optional(scope) ]) ) + scope_footer)
#~ > #~ scope << (scope_header + OneOrMore( Each([ Optional(wire_map), Optional(scope) ]) ) + scope_footer)
#~ > #~ scope << (scope_header + wire_map + scope_footer) # debug
#~ > #~ scope << (scope_header + ZeroOrMore(wire_map) + scope_footer) # debug
#~ > #~ scope << (scope_header + OneOrMore( Optional(wire_map) | Optional(scope) ) + scope_footer)
#~ > #~ scope << (scope_header + ZeroOrMore( (var_map | scope) ) + scope_footer) # ok now
#~ > scope << Group(scope_header + ZeroOrMore( (var_map | scope) ) + scope_footer) # with an extra group
#~ > #~ scope.setDebug()
#~ >
#~ >
#~ > #~ vcdpreamble = ( ZeroOrMore(date_header) + ZeroOrMore(version_header) + ZeroOrMore(timescale_header) )
#~ > vcdpreamble = ( Each([Optional(date_header), Optional(version_header), Optional(timescale_header)]) )
#~ > #~ vcdpreamble.setDebug()
#~ >
#~ > vcdheader = Forward()
#~ > #~ vcdheader << ( date_header + version_header + timescale_header + ZeroOrMore(scope) ) # better for debugging like this, then can go with each
#~ > #~ vcdheader << ( vcdpreamble + wire_map + ZeroOrMore(scope) + enddefs_footer) # better for debugging like this, with separate wire_map
#~ > #~ vcdheader << ( vcdpreamble + OneOrMore(var_map | scope) + enddefs_footer)
#~ > #~ vcdheader << ( vcdpreamble + OneOrMore( (var_map | scope) ) + enddefs_footer)
#~ > #~ vcdheader << ( vcdpreamble + OneOrMore( Each ([ Optional(var_map), Optional(scope) ]) ) + enddefs_footer)
#~ > #~ vcdheader << ( vcdpreamble + OneOrMore( ( Optional(var_map) | Optional(scope) ) ) + enddefs_footer)
#~ > #~ vcdheader << ( vcdpreamble + scope + enddefs_footer)
#~ > vcdheader << ( vcdpreamble +  ZeroOrMore( (var_map | scope) ) + enddefs_footer)
#~ > #~ vcdheader.setDebug()
#~ >

#~ Note, data parsing as of now:
#
#~ #2631990000
#~ 1!
#~ 1"
#~ 1#
#~ 1$
#~ #2632000000
#~ 0!
#~ 0#
#~ $dumpoff
#~ x!
#~ x"
#
#~ will be:
#
#~ tmpL_l[len-1]:
#~ [2631990000, ['!', '1'], ['"', '1'], ['#', '1'], ['$', '1']]
#
#~ dumpoffs:
#~ > [[2632000000,
#~ >   ['!', '0'], <====
#~ >   ['#', '0'], <====
#~ >   ['!', 'x'], <==== !!
#~ >   ['"', 'x'],


