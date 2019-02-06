

# Part 2: Running MATLAB in a Docker container.

When you just finished the Part 1 of this manual, your virtual machine is already running and you are ready to run MATLAB. You can continue with Part 2: step 2. Each next time you want to start MATLAB on the virtual machine, you need to start up the virtual machine first.

## Step 1: start your virtual machine
Start a windows command line session.

Start your virtual machine following the directions in the last sections of Part 1: [Windows 10 Pro](./Part-1-Windows10.md), [Windows 10 Home](./Part-1-Windows10Home.md).

Verify that docker is running correctly by typing the following command:

```
> docker version 
```
Version information should be displayed for Docker Client and for Docker Server.

Next, start the container by typing:

```
> docker start matlabuu
```

In Windows command prompt, run the following command

`docker exec -it -u user matlabuu bash`

> Alternatively, start an ssh session to your container using MobaXterm (the one you may have created in step 7 of part 1).

Activate display forwarding with the ```export DISPLAY=``` command (Part 1: step 8), and test whether this works by typing: ```xclock```. If a new window with a clock appears you are ready to run MATLAB.

## Step 2: start MATLAB

Make sure you are in your user directory:
```
$ cd ~
```
If starting MATLAB for the first time, create a directory for your scripts in the home directory.

```
$ mkdir scripts
```

Start MATLAB
```
$ matlab
```
MATLAB will start, this may take a short while.


## Step 3: Create a MATLAB script

In MATLAB, first navigate to the ‘scripts’ folder in your workspace.

Then open an empty script.

Copy the script [test_1](./test_1.m) and paste it in the editor.

Save the script as ```test_1.m```

Type ```exit``` in the command window to close MATLAB.

For instructions on how to adapt your own scripts to see [Part 3](./Part-3-Parallel-Matlab.md).

## Step 4: Compile and send to HPC

Use the SSH session to Docker container in MobaXterm for this step.

Now compile (translate) the script to machine language using the [mcc](https://nl.mathworks.com/help/compiler/mcc.html) command:

```
$ cd scripts
$ mcc -mv -o myExec test_1.m
$ ls -al
```
myExec is the compiled program and should now be listed in the folder.

Copy both files to your cluster using the scp command or manually.  

```
$ scp myExec <username>@lisa.surfsara.nl:/home/<username>/
```
Depending on the login requirements of the cluster you may be asked to fill in the password of your cluster account.

! This command does not work directly when copying to the UBC cluster as an SSH connection should be established using key pairs.
For more background on how to transfer data to UBC by establishing SSH/SCP connections see [Intro SSH & SCP](./ssh.md)

## Step 5: Submit job 

Now start an SSH session to the cluster with MobaXterm. For backgrounds of using HPC and submitting jobs see [Introduction to HPC](./HPC_Intro.md).

Create a job submission file:
```
# vim test1
```

Press ```i``` to enter insert mode.

Copy and paste the following text in the editor:

UBC
```
#!/bin/bash
module load mcr/v94           # mcr version should be same as matlab version
./myExec 200 1
module unload mcr/v94
```
LISA
```
#! /bin/bash

#SBATCH -N 1              # 1 node
#SBATCH --mem=32G         # with 32 GB memory
#SBATCH -t 00:10:00       # for 5 minutes

module load mcr/2017b         # mcr version should be same as matlab version
cd ./test
./myExec 200 1
module unload mcr

```

Type ```:wq``` to save and quit.

Now submit the job.

**For UBC:**

Submit the job using the following command:
```
# qsub test1
```

You can check the progress of your job using the ```qstat``` command:

```
# qstat -u <username>
```
This command lists the jobs that you have submitted. You can see which of your jobs are waiting in the queue and which of your jobs are running and how long they have been running. When a job is done, it will not be in the list anymore.

**For Lisa:**

Submit the job using the following command:
```
# sbatch test1
```
You can check the progress of your job using the ```squeue``` command:

```
# squeue -u <username>
```
This command lists the jobs that you have submitted. You can see which of your jobs are waiting in the queue and which of your jobs are running and how long they have been running. When a job is done, it will not be in the list anymore.

## Step 6: Check result

When the jobs are done, an error file and an output file are produced in the directory from where the jobs where submitted. 

```
<submission-filename>.e<job-id>   	(errorfile)
<submission-filename>.o<job-id>	    (outputfile)
```
Type:```ls``` to see if they are there.

You can open them using 
```
# vim <filename>
```
If all went well, the error file is empty.

The output file lists a combination of information from the cluster, the run, and any printed MATLAB output (note: the actual results are typically stored in a different file which should be specified in the MATLAB script).

The output file should look like this:

```
Start of test run
Elapsed time is 34.664538 seconds.
End of test run

< Potentially additional job-information from the cluster >

```
If yes, the job succeeded. 

You may proceed to [Parallelization of MATLAB scripts](./matlab.md), or end the session.

## Step 7: End sessions

End your ssh session to HPC in MobaXterm by typing ```# exit``` and press return.

End your ssh session to the Docker container in MobaXterm by typing ```# exit``` and press return.

Further, stop the container and virtual machine as explained in Part 1: [Windows 10 Pro](./Part-1-Windows10.md), [Windows 10 Home](./Part-1-Windows10Home.md).

## Links

[Introduction to Linux](./Linux_intro.md)  
[Introduction to Docker](./Docker_intro.md)  
[Introduction to HPC](./HPC_intro.md)  
[Intro SSH & SCP](./ssh.md) 
[Part 1: Windows 10 Enterprise](./Part-1-Windows10.md)
[Part 1: Windows 10 Home](./Part-1-Windows10Home.md)
[Part 1: Mac](./Part-1-Mac.md)
[Part 3: Parallelization of MATLAB scripts](./Part-3-Parallel-Matlab.md)  
[MATLAB Test script 1](./test_1.m)
