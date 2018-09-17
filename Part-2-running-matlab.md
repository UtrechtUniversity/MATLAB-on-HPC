

# Part 2: Running MATLAB on a virtual machine.

When you just finished the Part 1 of this manual, your virtual machine is already running and you are ready to run MATLAB. You can continue with Part 2: step 2. Each next time you want to start MATLAB on the virtual machine, you need to start up the virtual machine first.

## Step 1: start your virtual machine
Start a windows command line session.

Using command line, navigate to the directory where Docker is installed.

e.g.

```
...> cd /
C:\> cd Program Files/Docker Toolbox
```

Type: 
```
> docker-machine ls
```
to see which machines are available. 

The machine named default should be visible. 

Type: 
```
> docker-machine start default
``` 
to start the virtual machine.

Next, start the container by typing:

```
> docker start matlabuu
```
Now, start MobaXterm and doubleclick the ssh session to your container (the one you created in step 6).

Activate display forwarding with the ```export DISPLAY=``` command (Part 1: step 7), and test whether this works by typing: ```xclock```. If a new window with a clock appears you are ready to run MATLAB.

## Step 2: start MATLAB

Use the SSH session in MobaXterm for this step.
 
Navigate to matlab directory

```
# cd /
# cd usr/local/MATLAB/R2018a/bin
```
Create a test folder

```
# mkdir test
```
Start MATLAB
```
# ./matlab
```
## Step 3: Create a MATLAB script

In MATLAB, first navigate to the ‘test’ folder in your workspace.

Then open an empty script.

Copy the script [Test_1](./Test_1.m) and paste it in the editor.

Save the script as ```Test_1.m```

Type ```exit``` to close MATLAB.

## Step 4: Compile and send to HPC

Use the SSH session to Docker container in MobaXterm for this step.

Now compile the script using the [mcc](https://nl.mathworks.com/help/compiler/mcc.html) command:

```
#../mcc -mv -o myExec test_1.m
# ls
```
myExec is the compiled program and should now be listed in the folder.

Copy both files to cluster using the scp command or manually.  

```
# scp myExec <username>@lisa.surfsara.nl:/home/<username>/
```

For more background on how to transfer data see [Intro SSH & SCP](./ssh.md)

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
./myExecSerial 200 1
module unload mcr/v94
```
LISA
```
#PBS -lnodes=1 -lwalltime=00:10:00
module load mcr/2017b         # mcr version should be same as matlab version
cd ./test
./myExecSerial 200 1
module unload mcr

```

Type ```:wq``` to save and quit.

Now submit the job.

```
# qsub test1
```

You can check the progress of your job using the ```qstat``` command:

```
# qstat -u <username>
```
This command lists the jobs that you have submitted. You can see which of your jobs are waiting in the queue and which of your jobs are running and how long they have been running. When a job is done, it will not be in the list anymore.


## Step 6: Check result

When the jobs are done, an error file and an output file are produced in the directory from where the jobs where submitted. 

```
<submission-filename>.e<job-id>   	(errorfile)
<submission-filename>.o<job-id>	    (outputfile)
```
Type:```#ls``` to see if they are there.

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

In windows command line type 
```
> docker stop matlabuu
```
to stop the container.

In windows command line type 
```
> docker-machine stop default
```
to stop the virtual machine.

## Links

[Introduction to Linux](./Linux_intro.md)  
[Introduction to Docker](./Docker_intro.md)  
[Introduction to HPC](./HPC_intro.md)  
[Intro SSH & SCP](./ssh.md)  
[Parallelization of MATLAB scripts](./matlab.md)  
[MATLAB Test script 1](./Test_1.m)  
