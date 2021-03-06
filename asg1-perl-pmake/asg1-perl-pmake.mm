.so Tmac.mm-etc
.if t .Newcentury-fonts
.INITR* \n[.F]
.SIZE 12 14
.TITLE CMPS-112 Fall\~2014 Program\~1 "Perl and Rapid Development"
.RCS "$Id: asg1-perl-pmake.mm,v 1.76 2014-10-03 16:35:04-07 - - $"
.PWD
.URL
.GETST* SIGTOPERL_C Figure_SIGTOPERL_C
.GETST* SIGTOPERL_OUTPUT1 Figure_SIGTOPERL_OUTPUT1
.H 1 "Overview"
Scripting is a style of programming whereby small programs 
are developed rapidly.
This is also sometimes called rapid prototyping.
Perl is a language which supports this particular programming
paradigm very well because it is a very powerful and interpreted
language.
There is no need to do the usual compile-run cycle, since
the program is compiled every time it is run.
.P
One might claim that Perl is probably the best language for
the job in almost any instance where the program can be written in,
say, about an hour or less, and where the performance is not
unacceptable.
For large applications or those which require high performance,
it is not suitable.
Perl's most notable powerful features are powerful string manipulation
facilities, pattern matching, and hash tables as primitive elements.
.H 1 "An implementation of make"
In this assignment, you will use Perl to write a replacement for
a subset of
.V= gmake .
.SH=BVL
.B=LI "NAME"
pmake \[em] perl implementation of gmake
.B=LI "SYNOPSIS"
.V= pmake
.=V \|[ -d ]
.=V \|[ -n ]
.=V \|[ -f
.IR makefile ]
.RI \|[ target ]
.B=LI "DESCRIPTION"
The
.V= pmake
utility executes a list of shell commands associated with each
.IR target ,
typically to create or update files of the same name.
The
.IR Makefile
contains entries that describe how to bring a target up to date with
respect to those on which it depends,
which are called prerequisites.
.B=LI "OPTIONS"
.br
The following options are supported.
All options must precede all operands,
and all options are scanned by 
.V= Getopt::Std::getopts
(perldoc).
.VL \n(Pi
.LI "\f[CB]-d\f[R]"
Displays the reasons why make chooses to rebuild a target.
This option prints debug information,
or nothing at all.
Output is readable only to the implementor.
.LI "\f[CB]-n\f[R]"
Non-execution mode.
Prints commands, but does not execute them.
.LI "\f[CB]-f\f[R]\|\f[I]Makefile\f[R]"
.br
Specifies the name of the Makefile to use.
If not specified,
tries to use 
.V= ./Makefile .
If neither of those files exists, exits with an error message.
.LE
.B=LI "OPERANDS"
The following operand is recognized.
.VL \n(Pi
.LI "\f[I]target\f[R]
.br
An attempt is made to build each target in sequence in the
order they are given on the command line.
If no target is specified, the first target in the
.IR makefile
is built.
This is usually, but not necessarily, the target
.V= all .
.LE
.B=LI "EXIT STATUS"
.VL \n[Pi]
.LI 0
No errors were detected.
.LI 1
An error in the makefile was detected,
one that did not come from the execution of a subprocess.
.LI >0
An error was detected which caused 
.V= pmake
to stop execution, because of an error return from the subprocess.
In this case, the subprocess's exit code is returned.
.LE
.br
.ne 6
.B=LI "MAKEFILE SYNTAX"
.br
Generally, whitespace delimits words,
but in addition, punctuation is recognized as well.
Each line of input is a comment, an empty line, a dependency,
or a command.
.VL \n[Pi]
.LI \f[CB]#\fR
Any line with begins with a hash, possibly preceded by whitespace
(spaces and tabs) is ignored.
Empty lines consisting only of whitespace are also ignored.
.LI
\f[I]macro\f[R]\|\f[CB]=\f[R]\|\f[I]value\f[R]
.br
Macro definitions are kept in a symbol (hash) table, 
to be substituted later.
.LI
\fItarget\fR\|.\|.\|. \f[CB]:\fR \fIprerequisite\fR\|.\|.\|.
.br
Each target's time stamp is checked against the time stamps of
each of the prerequisites.
If the target or prerequisite contains a percent sign
.=V ( % ),
it is substituted consistently.
If any target is obsolete, the following commands are executed.
A target is obsolete if it is a file that is older than the 
prerequisites or does not exist.
A prerequisite is either a file or another target.
If a file, its time stamp is checked.
If not, the target to which is refers is made recursively.
No target is made more than once.
.LI \fIcommand\fR
.br
A command is any line for which the first character is a tab .
The line is echoed to 
.V= STDOUT
before executing the command.
The line is then passed to the
.V= system
function call for execution by the shell.
The resulting exit code is then tested.
If it is non-zero, 
.V= pmake
exits at that point with that exit code.
If the tab is followed by a minus sign
.=V ( - )
and white space,
the exit code is treated as 0.
The minus sign is not passed to the shell.
.LE
.B=LI MACROS
Whenever a dollar sign appears in the input file,
it represents a macro substitution.
Macros are substituted from innermost to outermost braces.
If a dollar sign is followed by any character except a left
parenthesis
.=V ( ( )
or left brace
.=V ( { )
that one character is the macro name.
Otherwise, the contents of the parentheses or braces are replaced.
.nr Pi2 \n[Pi]*2
.VL \n[Pi2]
.LI \f[CB]\[Do]\[Do]\fR
Represents the dollar sign itself.
.LI \f[CB]\[Do]<\fR
Represents the first file specified as a prerequisite.
.LI \f[CB]\[Do]@\fR
Represents the first file specified as a target.
.LI \f[CB]\[Do]{\fR\|.\|.\|.\|\f[CB]}\fR
The contents of the braces are substituted with the value of the
macro name, which may be multiple characters,
not including a closing brace.
.LE
.LE
.DF L
.B1
.SP
.ft CR
.nf
.eo
.pso cat -nv sigtoperl.c | expand
.ec
.fi
.ft R
.SP
.B2
.FG "\f[CB]sigtoperl.c\f[P]" "" 0 SIGTOPERL_C
.DE
.DF L
.B1
.SP
.ft CR
.nf
.eo
.pso sigtoperl | cat -nv | expand | grep -v Real-time
.ec
.fi
.ft R
.SP
.B2
.FG "Partial output from \f[CB]sigtoperl\f[P]" "" 0 SIGTOPERL_OUTPUT1
.DE
.H 1 Commentary
Here are some hints that will be useful in familiarizing yourself with
Perl and how to perform certain kinds of coding.
.ALX a ()
.LI
There are a lot of Perl scripts that may be used as examples in
the directory
.V= /afs/cats.ucsc.edu/courses/cmps112-wm/bin ,
which is a symlink to
.V= /afs/cats.ucsc.edu/courses/cmps012b-wm/bin .
.LI
The function
.V= system
will pass a comment string to the shell and set the variable
.V= \[Do]?
to the
.V= wait (2)
return value.
If the termination signal is 0 (bits 6...0),
then the program exited normally and bits 15...8 contain the
.V= exit (2)
status returned by the program.
Otherwise, bits 6...0 contain 
the signal that caused the program to terminate,
and bit 7 indicates whether or not core was dumped.
The following code can be used to extract this information\(::
.DS
.VCODE* 1 "my \[Do]term_signal = \[Do]? & 0x7F;"
.VCODE* 1 "my \[Do]core_dumped = \[Do]? & 0x80;"
.VCODE* 1 "my \[Do]exit_status = (\[Do]? >> 8) & 0xFF;"
.DE
.LI
Figure \*[Figure_SIGTOPERL_C]
shows a C program
.=V ( code/sigtoperl.c )
which prints out a description of all of the signals,
some of the output of which on this machine is shown in 
Figure \*[Figure_SIGTOPERL_OUTPUT1].
The complete output of this program may be inserted into your Perl
program.
.LI
Do
.E= not
cut and paste from the text file or the pdf.
If you use
.V= vi ,
you can insert it into your program with the command
.DS
.VCODE* 1 ".!./sigtoperl"
.DE
if the binary executable is in the current directory.
Presumably other editors have similar facilities.
.LI
Use the function
.V= system
to run the command.
.V= \[Do]?
is the
.V= wait (2)
exit status.
.LI
Keep all macros in a hash table.
.br
.ne 6
.LI
To extract the innermost macro substitution,
the following pattern will avoid nested macros\(::
.V= \[rs]\[Do]{[\(ha}]+} .
Alternately, you may wish to parse macro lines into an AST
matching braces.
Remember that regular expressions don't handle matched structures
but context free grammars do.
.br
.ne 5
.LI
Keep each target in a hash with the prerequisites and commands as a
reference to a list.
Hashes are used in Perl to represent structs.
Thus, the following will point
.V= \[Do]p
at a struct with two fields\(::
.DS
.VCODE* 1 "\[Do]p = {FOO=> 3, BAR=> [1, 2, 3]}"
.DE
.LI
The
.V= stat
function returns a list of file attributes.
The modification time is the value of interest when comparing
time stamps on files.
See
.V= perlfunc (1).
.DS
.VCODE* 1 "@filestat = stat $filename;"
.VCODE* 1 "my $mtime = $filestat[9];"
.DE
.LI
Look at the subdirectories
.V= .score/test*
and see what 
.V= gmake
does with them.
.LE
.H 1 "What to submit"
Submit one file, specifically called
.V= pmake ,
which has been
.V= chmod ed
to executable
.=V ( +x ).
The first line must be a hashbang for Perl.
Also, use
.V= strict
and
.V= warnings .
.DS
.VCODE* 1 "#!/usr/bin/perl"
.VTCODE* 1 "# " "Your name and username@ucsc.edu"
.VCODE* 1 "use strict;"
.VCODE* 1 "use warnings;"
.DE
.P
Your name and RCS
.V= \[Do]Id\[Do]
string must come
.E= after
the hashbang line.
Grading will be done by naming it as a shell script.
Do not run it by typing the word
.V= perl
as the first word on the command line.
.P
If you are doing pair programming, 
submit
.V= PARTNER
as required by the pair programming instructions in
.V= cmps112-wm/Syllabus/pair-programming .
.FINISH
