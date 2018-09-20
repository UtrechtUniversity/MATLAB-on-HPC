# Introduction to Linux

Most information on this page is composed from introduction manuals at the websites of [Surfsara](https://userinfo.surfsara.nl/systems/lisa/getting-started) and [University of Surrey](http://www.ee.surrey.ac.uk/Teaching/Unix/). Check these websites for more elaborate information.

---------------------------

## Commands

Most PCs have a graphical user interface: you interact with your computer by clicking on files, applications, etc. Most HPC systems are operated using Unix/Linux, where you communicate through a command line interface. When logged in with SSH session to your HPC system or Docker container: Try a couple of basic commands:

`who` shows you the list of users that are currently logged in on the same node.
`date` shows you the current date and time.
`top` shows you the list of processes currently running on the node, including how much resource (cpu, memory, etc) they use. Press q to return to the command line again.
`ls` shows the current files in your home directory (if you just logged in for the first time, it may well be empty).
`mkdir [mydir]` create a directory with name 'mydir'.
`cd [mydir]` change directory to directory 'mydir'.
`logout` logs you out of the SSH session.

In a command line session, for everything you want to do you have to use commands: to navigate between folders, to make or remove folders, to search for information or to start software. 

If the system is running a command that you want to interrupt, you can always use ctrl+c (try it with the `top` command).

## Navigating bewteen directories
For naviation you basically need three commands `pwd` (print working directory), `cd` (change directory), and `ls` (list files and directories in current folder).

To see in which directory you currently are type:

`pwd`

To see which files and folders are present in the current directory type:

`ls`

To make a new directory called mydir type:

`mkdir mydir`

Go to directory mydir

`cd mydir`

Type `pwd` to see the change in your directory path.

To go back to the previous directory type:

`cd ..`

Make another directory:

`mkdir mydir2`

Go to this directory: 

`cd mydir2`

`pwd`

Now go straight to the first created directory:

`cd ../mydir`

As you can see you don't need to jump between directories one at a time, but you can directly jump between directories if you specify the relative path. `.` means the current directory. `..` means one directory up. From there you could jump to as many next subdirectories as required e.g. `../mydir2/mydir3/mydir4` (note: as long as these subdirectories exist; mydir3 and mydir4 don't exist yet). 

You can use `cd /` to go to the 'root' directory and `cd ~` to go to your home directory.


## creating, moving and removing files and directories
For creating, moving and removing files and directories you need the following commands: `mkdir` (create directory), `cp` (copy files and directories), `mv` (move or rename files and directories) and `rm` (remove files and directories).

Go to `mydir`  
Now first create a file: `vim testfile`  
Now you enter text editor VIM (further explanation below).   
Press: `i` to enter insert mode.  
Insert some text: `some text`  
Press `Esc` button to exit insert mode.  
Press: `:wq` to save and quit.  

Type `ls`. You will see the file named `testfile` is now present in this folder.

Now create a new directory:
`mkdir ../mydir2/mydir3`

Using relative pathnames you now created directory `mydir3` in directory `..` one up and inside `/mydir2`. Type `pwd` to see that you are still working in `mydir`.

Now copy `testfile` to `mydir3` (syntax: `cp <file> <destination>`)

`cp testfile ../mydir2/mydir3`

The file is copied to `mydir3` and also still present in the current folder, see `ls`.

Now navigate to the `mydir3` using the `cd` command.

When you are in `mydir3` check whether the testfile is indeed copied to the folder with `ls`.

Now remove the file with the `rm` command.

`rm testfile`

You can also copy files from a distant folder to the current directory:

`cp ../../mydir/testfile ./`

Relative from my current directory, the file is two directories up, then inside the directory `mydir`. The destination is the current directory `./`.

Other options for the copy command:
`cp -i <file1> <file2>`  
This command copies the contents of file1 into file2. If file2 does not exist, it is created; otherwise, it is asked whether file2 should be overwritten with the contents of file1.

`cp -R <dir1> <dir2>`  
This command copies the contents of the directory dir1. If directory dir2 does not exist, it is created. Otherwise, it creates a directory named dir1 within directory dir2.


It is also possible to move one or more files or directories instead of copying with the `mv` command (syntax: `mv <file1> <file2> <file3> <dir1>`).

type:

`mv testfile ../../mydir`

now the current directory is empty and testfile is back at its original location.

	
Other options: Move an entire directory
`mv <dir1> <dir2>`  
If dir2 does not exist, then dir1 is renamed dir2. If dir2 exists, the directory dir1 is moved within directory dir2.

**Caution with rm command**

Removing a file or a folder with `rm` cannot be undone.

## Commands with parameters (flags)
Many commands have a number of different options that can be activated with a `-` followed by a letter. E.g. `ls -l`.
To see which options exist for a command you can open the manual:
`man ls`.

Go to the directory where `testfile` is located: `cd ../../mydir`.
Note the difference between:
`ls`
`ls -l`

## Recall commands

You can recycle commands that you have typed earlier, which saves you a lot of time.  
After you have typed in a few commands, use the arrow-up and arrow-down keys to see previous commands. Execute a previous command by pressing Enter. You can also edit previous commands if you need to run a command which is only slightly different.

## Command completion

If you type enough characters of a command or a filename to help the system identify what you mean, you can press tab to let the system finish the command or filename or foldername. This will also save you a lot of time. To test go 1 directory up: `cd ..`.
Type: `cd my` and press the tab key. The system will automatically add the letters `dir` as there are not other options. However, there are two folders that start with `mydir` (`mydir` and `mydir2`). If you want to go to `mydir2`, simply add `2` and press enter.

Navigate to `mydir3` from `cd ~` as follows:  
`cd my` tab key `2/my` tab key and enter. When you have practiced a bit, this will become an automatism.


## Permissions

Go to the directory where `testfile` is located: `cd ../../mydir`.

Type:
`ls -l`

You will see the first characters will look like this:

`-rw-------`

These are the permissions the user has for the specific file.

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

Changing permission bits is done with the command `chmod` (change file mode bits), type:

`chmod -w testfile`
`ls -l`      

The output should be

`-r--------` 

Now it is not possible to change the file.

Fix this situation with:

`chmod +w testfile`

This becomes sometimes an issue when you copy a compiled MATLAB code to the cluster. When there is no permission to execute this file, the job refering to this file will give an error.
Solve this by simply giving permission using the `chmod` command.

`chmod +x <matlabexecutable>`

## Viewing and editing text files
VIM is a basic text editor that is used in this manual to create, edit and view text files, job scripts, MATLAB scripts etc. 

Start VIM using the `vim` command:

`vim <filename>`. If the file exists, it will be opened. If it doesn't exist, a new file will be created with this name.

VIM will open in command mode. To edit a file, you need to go to insert mode by typing `i`.

Now all arrow keys and alphabetical keys will behave as expected. 

To exit insert mode hit the Esc key.

In command mode you can save the file with `:w` and enter.
To quit without saving type `:q!`
To save and quit `:wq`
To save under a different filename `:sav testfile2`. Note that if you now continue and make new edits in insert mode, you are still working in the initial file and not in the newfile `testfile2`. To make these edits in `testfile2` only, `:wq` and `vim testfile2`. Or keep working and save later using `:sav testfile2` again, and exit the initial file without saving `:q!`.

To learn more about VIM find a beginners guide online or use this [interactive guide](https://www.openvim.com/).

## Searching files
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


## Filenames

We should note here that a directory is merely a special type of file. So the rules and conventions for naming files apply also to directories.

In naming files, characters with special meanings such as / * & % , should be avoided. Also, avoid using spaces within names. The safest way to name a file is to use only alphanumeric characters, that is, letters and numbers, together with _ (underscore) and . (dot).
Good filenames 	Bad filenames
project.txt 	project
my_big_program.c 	my big program.c
fred_dave.doc 	fred & dave.doc

File names conventionally start with a lower-case letter, and may end with a dot followed by a group of letters indicating the contents of the file. For example, all files consisting of C code may be named with the ending .c, for example, prog1.c . Then in order to list all files containing C code in your home directory, you need only type ls *.c in that directory. 



## Usage of Matlab software


./matlab
./matlab -...



