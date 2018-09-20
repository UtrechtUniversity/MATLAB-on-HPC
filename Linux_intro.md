# Introduction to Linux

Most information on this page is composed from introduction manuals at the websites of [Surfsara](https://userinfo.surfsara.nl/systems/lisa/getting-started) and [University of Surrey](http://www.ee.surrey.ac.uk/Teaching/Unix/). Check these websites for more elaborate information.

---------------------------
Most PCs have a graphical user interface: you interact with your computer by clicking on files, applications, etc. Most HPC systems are operated using Unix/Linux, where you communicate through a command line interface. When logged in with SSH session to your HPC system or Docker container: Try a couple of basic commands:

    `who` shows you the list of users that are currently logged in on the same node.
    `date` shows you the current date and time.
    `top` shows you the list of processes currently running on the node, including how much resource (cpu, memory, etc) they use. Press q to return to the command line again.
    `ls` shows the current files in your home directory (if you just logged in for the first time, it may well be empty).
    `mkdir [mydir]` create a directory with name 'mydir'.
    `cd [mydir]` change directory to directory 'mydir'.
    `logout` logs you out of the SSH session.

If the system is running a command that you want to interrupt, you can always use ctrl+c (try it with the top command).




Commands

Commands with parameters (flags)

Recall commands

After you have typed in a few commands, use the arrow-up and arrow-down keys, and you see what we mean. You can even edit previous commands by using the following keys: Backspace, Delete, arrow-left, arrow-right and of course all alphanumerical keys. Try it!
Command completion

The shell is always willing to assist you. In general, you can type a few characters of a command or a filename followed by a 'Tab' character. The shell will then try to 'complete' the word you are typing. Very useful with long filenames, for example. This feature is a bit difficult to describe, it is better to try it out and see what happens.

Files and folders (directories)

Navigation + creating and moving files and directories*


rm 
*asf

Hidden files

Hidden files are used when one does not want the user to annoy with files she will probably never or seldom change herself. A file whose name starts with a dot ('.') will not be shown, and also not be the result of a filename expansion. Example, type:
ls -a

Permissions
chmod

The meaning of the first four characters is:

 1 '-': it is a normal file
   2 '-': the owner cannot read the file
     'r': the owner can read the file
   3 '-': the owner cannot change the file
     'w': the owner can change the file
   4 '-': the owner cannot execute the file
     'x': the owner can execute the file
 1 'd': it is a directory
   2 '-': the owner cannot read the directory: ls does not work
     'r': the owner can read the directory: ls works
   3 '-': the owner cannot create or delete files in that directory
     'w': the owner can create or delete files in that directory
   4 '-': the owner cannot cd to the directory
     'x': the owner can cd to the directory

Changing permission bits

Changing permission bits is done with the command 'chmod' (change file mode bits), type:

chmod -x mydir
ls -ld mydir          # notice : -ld, not -l
cd mydir

The output should be

drw------- 2 wiltest wiltest 3 2010-03-19 13:57 mydir
bash: cd: mydir: Permission denied

Indeed, you removed the x bit an cannot cd to the directory anymore. Fix this situation with:

chmod +x mydir

and experiment if you can cd to the directory again.

Special directories . and ..

These two extra directories have names: . and .. . stands for 'current directory', it is equal to the directory 'where you are'.

.. stands for the directory in which the current directory is located. So, to go one directory back, you can type:

cd ..

Also constructs like this can come in handy:

cd ../simple

Viewing and editing files
VIM

less

The command less writes the contents of a file onto the screen a page at a time. Type

% less science.txt

Press the [space-bar] if you want to see another page, and type [q] if you want to quit reading. As you can see, less is used in preference to cat for long files.

 
head

The head command writes the first ten lines of a file to the screen.

First clear the screen then type

% head science.txt

Then type

% head -5 science.txt

What difference did the -5 do to the head command?

 
tail

The tail command writes the last ten lines of a file to the screen.

Clear the screen and type

% tail science.txt 


Simple searching using less

Using less, you can search though a text file for a keyword (pattern). For example, to search through science.txt for the word 'science', type

% less science.txt

then, still in less, type a forward slash [/] followed by the word to search

/science

As you can see, less finds and highlights the keyword. Type [n] to search for the next occurrence of the word.

 
grep (don't ask why it is called grep)

grep is one of many standard UNIX utilities. It searches files for specified words or patterns. First clear the screen, then type

% grep science science.txt

As you can see, grep has printed out each line containg the word science.

Or has it ????

Try typing

% grep Science science.txt

The grep command is case sensitive; it distinguishes between Science and science.

To ignore upper/lower case distinctions, use the -i option, i.e. type

% grep -i science science.txt

To search for a phrase or pattern, you must enclose it in single quotes (the apostrophe symbol). For example to search for spinning top, type

% grep -i 'spinning top' science.txt

Some of the other options of grep are:

-v display those lines that do NOT match
-n precede each matching line with the line number
-c print only the total count of matched lines

Try some of them and see the different results. Don't forget, you can use more than one option at a time. For example, the number of lines without the words science or Science is

% grep -ivc science science.txt 

find

This searches through the directories for files and directories with a given name, date, size, or any other attribute you care to specify. It is a simple command but with many options - you can read the manual by typing man find.

To search for all fies with the extention .txt, starting at the current directory (.) and working through all sub-directories, then printing the name of the file to the screen, type

% find . -name "*.txt" -print

To find files over 1Mb in size, and display the result as a long listing, type

% find . -size +1M -ls 


4.2 Filename conventions

We should note here that a directory is merely a special type of file. So the rules and conventions for naming files apply also to directories.

In naming files, characters with special meanings such as / * & % , should be avoided. Also, avoid using spaces within names. The safest way to name a file is to use only alphanumeric characters, that is, letters and numbers, together with _ (underscore) and . (dot).
Good filenames 	Bad filenames
project.txt 	project
my_big_program.c 	my big program.c
fred_dave.doc 	fred & dave.doc

File names conventionally start with a lower-case letter, and may end with a dot followed by a group of letters indicating the contents of the file. For example, all files consisting of C code may be named with the ending .c, for example, prog1.c . Then in order to list all files containing C code in your home directory, you need only type ls *.c in that directory. 



Usage of Matlab software




