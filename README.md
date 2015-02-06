> 
> README.md
> =================================================
> Author: Michael B Hynes, mbhynes@uwaterloo.ca
> License: GPL 3
> Creation Date: Fri Feb  6 15:47:24 2015
> Last Modified: Fri Feb  6 15:58:50 2015
> =================================================

~/bin
================
Contains my shell scripts and binaries I've borrowed from
others.

Contents:

baraction -- script for spectrwm bar

catsub
==========

 catsub -1 n1 -2 n2 [file1 file2 ...]

 Print lines [n1 ... n2] of files, inclusive. 
 Error checking is performed on n1,n2 to ensure:
  1. n2 >= n1
 
 If -1 n1 or -2 n2 are unspecified, n1 = 1; n2 = EOF

 =================================================
Options:
	1)	line1="$OPTARG"	#first	line	of	subsection	
	2)	line2="$OPTARG"	#last	line	of	subsection	

clip
==========
Copy primary selection to clipboard and print it.
$ xclip -o $src | xclip $dest

ext
==========

 ext [-l] [file1 file2 ...]

 Print the file extension of input files.

 The extension is taken (by default) as the of the
 shortest suffix beginning with a period.
 
 Specifying -l will find the longest suffix beginning with
 a period (search from the "leftmost" character of the
 string)

 >> ext test.png test.png.old .rc test
 .png
 .old
 .rc
 <nullstring>

 >> ext -l test.png test.png.old .rc test
 .png
 .png.old
 .rc
 <nullstring>


Options:
	l)	read_from_left="true"	

filesum
==========
CLI to octave; adds matrices in textfiles

filter
==========
CLI to octave's filter() fn

googbib
==========
Copy bibtex information from clipboard into a bibtex entry
in $BIB_DIR.

gplot
==========
usage: /home/mike/bin/gplot -o fout [opts] fin1 fin2 ...
 plot multiple files on single plot with gnuplot

 add character escapes to certain strings
Options:
	t)	timeformat="$OPTARG"	
	X)	xrange="$OPTARG"	
	Y)	yrange="$OPTARG"	
	F)	filled="true"	
	s)	terminal_size="$OPTARG"	
	T)	terminal="$OPTARG"	
	w)	linewidth="$OPTARG"	
	f)	font="$OPTARG"	
	o)	fout="$OPTARG"	
	e)	errorbars="true"	
	x)	xtit="$OPTARG"	
	y)	ytit="$OPTARG"	
	L)	#	read	legend	strings	into	array	read	
a	legend	<<<	"$OPTARG"	
	P)	leg_pos="$OPTARG"	
	h)	header="$OPTARG"	

gplotcols
==========
usage: /home/mike/bin/gplotcols -o fout_prefix [opts] fin
 plot a file's columns on single plot


Options:
	t)	timeformat="$OPTARG"	
	s)	size="$OPTARG"	
	T)	terminal="$OPTARG"	
	w)	linewidth="$OPTARG"	
	f)	font="$OPTARG"	
	o)	fout="$OPTARG"	
	e)	errorbars="true"	
	x)	xtit="$OPTARG"	
	y)	ytit="$OPTARG"	
	L)	#	read	legend	strings	into	array	read	
a	legend	<<<	"$OPTARG"	
	P)	leg_pos="$OPTARG"	
	h)	header="$OPTARG"	

hist
==========
CLI interface to octave hist() fn

interp
==========
CLI interface to octave interp() fn

lsown
==========
List files belonging to $USER in the given directories
This script is slow and dumb. It's just to supprss warning
messages when deleting files from /tmp on a shared env.

makegif
==========
 makegif -o output.gif [f1 f2 ...]

 Greate gif from given image files.

 This is a wrapper to ttygif:
 https://github.com/icholy/ttygif
 
 If -t is specified, the timestamp in the filename 
 as produced by ttygif will be used.

 Else, the files will be concatenated using a constant
 delay time, defaulting to -delay 100 #ms 

 If -d delay is specified, then the resultant gif 
 will be concatenated using /usr/bin/convert with the
 -delay flag.


Options:
	D)	delete_input_files="true"	
	o)	output_filename="$OPTARG"	
	t)	use_timestamp="true"	
	d)	delay="$OPTARG"	

meanstd
==========
Octave CLI interface to std() fn

mp2pdf
==========

 mp2pdf [file1.mp file2.mp ...] 

 Run mptopdf on files to produce:
  file1.pdf file2.pdf ... *.pdf

 Just a quick fix to avoid having file1-0.mp, etc.

mtm
==========

 mtm - [M]ake la[T]ex [M]acros
 
 Create a list of latex macros from input files with syntax:
   cmd # command_text 
   cmd command_text

 From the above, the following output is produced:
 \newcommand{cmd}[#]{command_text}
 \newcommand{cmd}{command_text}

 EXAMPLE:

 dist \bigcup_i\mathcal{P}_i
 max 2 \mathbb{max}\left(#1,#2\right)

 produces:

 \newcommand{\dist}{\bigcup_i\mathcal{P}_i}
 \newcommand{\max}[2]{\mathbb{max}\left(#1,#2\right)}
 
 If the output of this file is stored in macros.tex,
 a tex file with \input{macros} may use 
 $\max{p}{q}$ 
 as a valid macro 

 Internally, this is a wrapper for a short sed script


namepaper
==========


 namepaper [-p] [-b] [-c] [-d <delim_string>] file.bib file2.bib 

 Print the a unix filename for a paper using the specified bibliographic entry
 Alternatively, print the unix filename for a bibtex entry using the specified
 bibliographic entry

 If the -c flag is given, use the system clipboard instead of a bibtex file

 Tested to work with google scholar's bibtex export, since theirs is the
 cleanest.

 Stupid filename characters; ie <' " @  $ % ( ) [ ] { } ? _ & . ,> are
 deleted. Duh.

 For -p[rint_paper_name] flat, -d <delim_string> will use
 delim_string in the filename; the default is "__", giving:
 author__papertitle__year.pdf

Options:
	p)	print_paper_name="true"	
	b)	print_bib_name="true"	
	d)	_fname_delim="$OPTARG"	
	c)	use_clipboard="true"	

ncols
==========

 ncols 

 Count the number of columns in given files
 -d <delim_char> specifies the fieldsep (default: ',')


Options:
	d)	delim="$OPTARG"	

note
==========
 
 note - an automated journaling script

 note [-L -d -o -H -F -h] [ [year1 [month1 month2 ...] ] year2 ...]

 Running note without arguments creates the file:
 $JOURNAL_DIR/year/month/year.month.day.tex
 and runs $EDITOR on this file, or vim by default.

 note [year1 year2 ...] compiles all of the entries from
 those years into a pdf file.
 
 note [year1 [month1 month2 ...] ] ... compiles just those
 months from the preceding year
 
 The header and footer for the output pdf are (default) specified in
 this script by:
    JOURNAL_DIR=~/journal
    FOUT=$JOURNAL_DIR/out.tex
    HEADER=$JOURNAL_DIR/header.tex
    FOOTER=$JOURNAL_DIR/append.tex

 To compile all the entries with pdflatex, specify -L, and
 provide years/months.


Options:
	L)	RUN_PDFLATEX_FLAG="true"	
	d)	JOURNAL_DIR="$OPTARG"	
	o)	FOUT="$OPTARG"	
	H)	HEADER="$OPTARG"	
	F)	FOOTER="$OPTARG"	
	h)	print_help	

parse_opts.m
==========
Octave script

Parse command-line arguments for octave scripts in
the style of getopts.

%sers must specify the following global (cell) variables:
%global OPT_VAR_NAMES; --- {'varname1' 'varname2' ... }
%global OPT_VAR_FLAGS; --- {'x' 'v' 'f' ...}
%global OPT_VAR_DEFAULTS;  --- {'var1_default_val' ...}
	global OPT_FLAG_HASARGS; {'x' 'v'} if these flags require args

Then, in the main script, one may call parse_opts as a script:
 	parse_opts
The variables named in OPT_VAR_NAMES will then be created 
in the main function scope.

The variables [OPTFLAGS OPTARGS OPTFILES] are also created;
these contain the flags read, the args for the flags, and any
non-flag parameters given (assumed to be files)

%xample: >> testfunc -f -x x_arg file1 -v v_arg file2 file3 
	OPTFLAGS = {'f' 'x' 'v'} 
PTARGS = {'x_arg' 'v_arg'} 
	OPTFILES = {'file1' 'file2' 'file3'} 

Each variable is initialized to either the default value, or the supplied
value from the commandline, which is evaluated using an eval() statement.

Flags in OPT_FLAG_HASARGS are like "x:v:" in a getopts OPTSTRING. 

Messages are written to stderr about *all* flags read, warnings, etc.

The function mat = read_mat_stdin() reads a matrix from the stdin.

pdfcat
==========
 pdfcat -o <outputfile> fin1 fin2 ... 
 
 Concatenate pdf files into a single file with gs
 
Options:
	o)	fout="$OPTARG"	

proper_noun
==========
Converts strings in stdin to "Proper Nouns"

rmoffset
==========
Octave CLI script; remove first element from matrix columns

screencast
screencast: ERROR: output file not specified.

 screencast
 1. use scrot to take slices of images of a window
 2. convert the images into a single gif

 There are better ways to do this; see ttygif. I wrote it
 more for fun than anything else. It will work fine for
 small gifs.



Options:
	w)	whole_screen="
m"	#	Boolean:	use	the	whole	screen	or	not	
	f)	frame_rate="$OPTARG"	#frames	/	second	
	q)	quality="$OPTARG"	#	quality	of	images	from	scrot	\in	[0,100]	
	d)	output_directory="$OPTARG"	
	p)	file_prefix="$OPTARG"	
	t)	filetype="$OPTARG"	
	r)	resize_percentage="$OPTARG"	

showram
==========
Show the system ram

tme
==========
Perl script to expand tex macros---not mine.

ttygif
==========
binary to make screencasts; not mine.
