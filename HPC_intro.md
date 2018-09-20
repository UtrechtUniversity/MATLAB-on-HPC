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


**Job scripts**
The examples below are used to submit 'myExec' (the compiled MATLAB program [Test_1.m](./Test_1.m) ), with input 200 and 1. The program is located in the directory `./test`. The program Matlab Compiler Runtime is used to run the executable. You can see that different versions are installed on the different systems. mcr/v94 is

**LISA**
```
#PBS -lnodes=1:ppn=1 -lwalltime=00:10:00  # Ask for resources
module load mcr/2017b                     # Load Matlab Compiler Runtime
cd ./test                                 # Navigate to directory of executable
./myExec 200 1                            # Run Executable with input: 200 and 1
module unload mcr                         # Unload Matlab Compiler Runtime 
```

(can give error in next job when mcr is not unloaded)

**UBC**

```
#!/bin/bash                               # Tell shell to use bash interpreter
module load mcr/v94                       # Load Matlab Compiler Runtime (has to match Matlab version that is used to compile script)
cd ./test                                 # Navigate to directory of executable
./myExec 200 1                            # Run Executable with input: 200 and 1
module unload mcr/v94                     # Unload Matlab Compiler Runtime
```



Job submission syntax and options


qsub -l h_rt=00:15:00  -l h_vmem=5G script.sh



qsub
qdel 
qstat



