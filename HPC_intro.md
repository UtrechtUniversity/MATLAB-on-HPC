# What is a cluster computer

Most information on this page is composed from introduction manuals at the websites of Surfsara and is slightly adapted for general application. For a more elaborate manual, visit their [website](https://userinfo.surfsara.nl/systems/lisa/getting-started).
The website of [Surfsara](https://userinfo.surfsara.nl/systems/lisa/getting-started) has a perfect explanation of what a HPC cluster is:

_"You can imagine a cluster computer as a collection of regular computers (known as nodes), tied together with network cables that are similar to the network cables in your home or office. Each node has its own CPU, memory and disk space, in addition to which they generally have access to a shared file system. On a cluster computer, you can run hundreds of computational tasks simultaneously._

_Interacting with a cluster computer is different from a normal computer. Normal computers are mostly used interactively, i.e. you type a command or click with your mouse, and your computer instantly responds by e.g. running a program. Cluster computers are mostly used non-interactively._ 

_A cluster computer such as Lisa has (at least) two types of nodes: login nodes and batch nodes. You connect through a login node. This is an interactive node: similar to your own pc, it immediately responds to the commands you type. There are only a few login nodes on a cluster computer, and you only use them for light tasks: writing and compiling software, preparing your input data, writing job scripts. Since the login nodes are only meant for light tasks, many users can be on the same login node at the same time._

_Your 'big' calculations will be done on the batch nodes. These perform what is known as batch jobs. A batch job is essentially a recipe of commands (put together in a job script) that you want the computer to execute. Calculations on the batch nodes are not performed right away. Instead, you submit your job script to the job queue. As soon as sufficient resources (i.e. batch nodes) are available for your job, the system will take your job from the queue, and send it to the batch nodes for execution."_ 

Each node has a number of cores (or processors) that can be used for parallel computations to speed up calculations.

## Login and file transfer 

Login and transferring files to HPC is explained [here](./ssh.md).

## Navigation in Linux

Most PCs have a graphical user interface: you interact with your computer by clicking on files, applications, etc. Most HPC systems are operated using Unix/Linux, where you communicate through a command line interface. When you are new to Linux, you can follow this [manual](./Linux_intro.md).

## Jobs

As mentioned above, all major calculations will be done on batch nodes. This means that you prepare a "batch job"" on a login node and submit this job to a batch node. How to submit a job differs slightly between LISA and UBC clusters and is explained below.


### Job scripts

At job script can be created with a text editor such as VIM (see [Introduction to Linux](./Linux_intro.md) ). 
The examples below are used to submit 'myExec' (the compiled MATLAB program [Test_1.m](./Test_1.m) ), with input 200 and 1. 

**LISA**

```
#PBS -lnodes=1:ppn=1 -lwalltime=00:10:00  # Ask for resources
module load mcr/2017b                     # Load Matlab Compiler Runtime (has to match Matlab version that is used to compile script)
cd ./test                                 # Navigate to directory of executable
./myExec 200 1                            # Run Executable with input: 200 and 1
module unload mcr                         # Unload Matlab Compiler Runtime 
```
save as: `jobscript.sh`

**UBC**

```
#!/bin/bash                               # Tell shell to use bash interpreter
module load mcr/v94                       # Load Matlab Compiler Runtime (has to match Matlab version that is used to compile script)
cd ./test                                 # Navigate to directory of executable
./myExec 200 1                            # Run Executable with input: 200 and 1
module unload mcr/v94                     # Unload Matlab Compiler Runtime
```
save as: `jobscript.sh`

The program is located in the directory `./test`. The program Matlab Compiler Runtime (MCR) is used to run the executable. You can see that different versions are installed on the different systems. The MCR version has to match the MATLAB version that is used to compile the MATLAB program. `mcr/v94` is the version belonging to MATLAB R2018a. You can check which versions of MCR are available using the `module avail` command. The 'module' `mcr` should be unloaded at the end of the job script. It can give errors in your next job when `mcr` is not unloaded in the previous job, or if there was an error in the previous job before unloading `mcr`. In the LISA job script, resources are requested in the first line. `-lnodes=1:ppn=1` means 1 node is requested, with 1 processor per node (ppn=1). 1 node is the maximum for running MATLAB. The maximum number of processors per node depends on the system (16 at LISA). `-lwalltime=00:10:00` means a maximum of 10 minutes is reserved on the assigned node. 
On UBC resources are requested when submitting the job script.  
When you use many or large input files, it may be beneficial to use scratch space. See instructions how to specify this in your jobscript for LISA [here](https://userinfo.surfsara.nl/systems/lisa/user-guide/creating-and-running-jobs).



## Job submission syntax and options

A job can be submitted by using the `qsub` command at the command line of the login node of the cluster. You must be in the same directory where your jobscript is saved.

**LISA**
```
qsub  jobscript.sh
```

**UBC**
```
qsub -pe threaded 16 -l h_rt=00:05:00  -l h_vmem=5G jobscript.sh
```

At UBC you have to request resources after the `qsub` command. If you don't specify anything, you will ask for 1 core, 10 minutes and 10 GB of memory by default. Specify the number of cores with `-pe threaded <##>`, the maximum walltime for the job with `-l h_rt=<HH:MM:SS>` and the required memory with `-l h_vmem=<#>G`.

## Job ID

When you submit a job, you receive a code which is an identifier of your job. You can use it to track progress, identify the error and output files and to delete the job when you don't want to run it anymore.

To delete a job:

`qdel <job id>`

To see the progress of all your jobs:

`qstat -u <username>`

## Wall clock time
With the walltime option a maximum of amount of time is reserved on the assigned node. When this time is reached the job will be killed regardless of whether the job has finished or not. So choose your wall clock time carefully, or save data at regular checkpoints.
The duration can be specified in HH:MM:SS format (as in the example). The maximum walltime that can be requested depends on the system (check for [LISA](https://userinfo.surfsara.nl/systems/lisa/user-guide/creating-and-running-jobs) or [UBC](https://wiki.bioinformatics.umcutrecht.nl/bin/view/HPC/FirstTimeUsers#Submission_of_jobs) ). To run longer lasting programs save your data on checkpoints and restart the job from this checkpoint.

It is recommended to time a minimal version of your computational task in order to estimate how long the total task will take. Then, choose your wall clock time liberally based on your expected runtime (e.g. 1.5-2x higher). Once you gain more experience in running similar-sized jobs, you could consider setting walltimes more accurately, as smaller jobs are slightly easier for the scheduler to fit in.

It is also recommended to submit a 5 minute test of your large job before submitting the complete job. This will highlight any errors in the jobscript or in the initialization part of your script (where most errors occur typically). Jobs with a walltime of 5 minutes have priority in the que so you will find out about these errors quite quickly in this way. 


Links / references
[LISA getting started](https://userinfo.surfsara.nl/systems/lisa/getting-started)
[LISA creating and running jobs](https://userinfo.surfsara.nl/systems/lisa/user-guide/creating-and-running-jobs)
[UBC submission of jobs](https://wiki.bioinformatics.umcutrecht.nl/bin/view/HPC/FirstTimeUsers#Submission_of_jobs)
