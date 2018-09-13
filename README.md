---
output:
  pdf_document: default
  html_document: default
---
# MATLAB-on-HPC contents

Part 1: Installation

Part 2: Usage of MATLAB

Part 3: Parallel computing with MATLAB

# Introduction


# Part 1: Preparation. Create a virtual machine and install Matlab

The steps in this part only need to be executed once.

## Step 1: Install Docker software on PC (Windows 10 Pro)

Download Docker Community Edition (CE) via:  
https://store.docker.com/editions/community/docker-ce-desktop-windows

Double-click the Docker for Windows Installer to run the installer

Note: if you get the following error: Installation failed: one pre-requisite is not fulfilled, you may have a different Windows edition. Required Windows 10 Pro.  

Option 1: Recommended by Docker: Upgrade to Windows 10 **Pro**: Costs for updating to without a license: 145 euro 

Option 2: Install Docker Toolbox (see step 1c).

To check which Windows version you have: press Windows key + I > system > about

* Step 1b: Install Docker software on PC (mac)

Download Docker Community Edition (CE) via:   
https://store.docker.com/editions/community/docker-ce-desktop-mac

* Step 1c: Install Docker software on PC (Windows 10 Home)

Download Docker Toolbox via:   
https://docs.docker.com/toolbox/toolbox_install_windows/

Double-click the Docker for Windows Installer to run the installer.

## Step 2: Start Docker software

Start a command line session

For some background and basic functions of windows command line see [Windows Command Line](./CMD.md)  

Navigate to the directory where Docker is installed.

e.g.

```
...> cd /
C:\> cd Program Files/Docker Toolbox
```
Type the following command:

```
> docker version 
```
Information should be displayed for Docker Client and for Docker Server.

## Step 3: Create a virtual machine

Now you will create a virtual machine with the name ‘default’. The example below has 3 cores  (–virtualbox-cpu-count 3), a storage disk with 100 GB storage (--virtualbox-disk-size "100000") and 3 GB RAM (--virtualbox-memory 3000). These values can be adapted if required. Too much RAM may slow down your working station. 

Type the following command:
```
> docker-machine create -d virtualbox –virtualbox-cpu-count 3 --virtualbox-disk-size "100000" --virtualbox-memory 3000 default
```

Now type the following commands to set the docker environment to the newly created machine:

```
> docker-machine env default
> @FOR /f "tokens=*" %i IN ('docker-machine env default') DO @%i
```

! If you have used docker before, there may already exist a virtual machine named 'default'. 
You can remove the other machine, or choose a different name. See [Introduction to Docker](./Docker_intro.md) for more information about this.

## Step 4: Pull Docker Image

Several Docker Images with different versions of MATLAB have been prepared by UU ITS. For an overview, type:

```
> docker search uumatlabinstall
```

Before pulling a Docker Image, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster that you will be using (check this using the module avail command; see [Introduction to Linux](./Linux_intro.md) and [Introduction to HPC](./HPC_intro.md)), if this is the first time you use Linux or login to a cluster. The Docker Image should feature the same MATLAB version as one of the mcr versions installed on the HPC system. 

Pull the image that you need by typing e.g.:

```
> docker pull uumatlabinstall/matlab-hpc-compile:matlab2018a
```
## Step 5: Start docker container

Type the following command to start a docker container:

```
> docker run -d -p 23:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:matlab2018a
```

Verify if the container named matlabjt is running:

```
> docker ps
```

## Step 6: Start SSH session to Docker container (user: root)

For this step you need a Desktop SSH client. For backgrounds of SSH sessions see [SSH & SCP](./ssh.md)  

Recommended software for SSH is MobaXterm, available at https://mobaxterm.mobatek.net/

Open MobaXterm
Start an SSH session: Click Session > SSH

Fill in the following fields: 
Remote host: < IP – address >      	
Username: root   	
Port: 23 
The IP - address that needs to be filled in can be found via windows command line using $  docker-machine ls)

Under Bookmark settings, choose a session name (e.g. Docker).

Click OK to start the session
When you are asked for a password, fill in:
Password: wijzigen


## Step 7: Activate display forwarding in Docker container

Use the SSH session in MobaXterm for this step.
 
Set X11 Server display port: 

```
# export DISPLAY=<xxx.xxx.xxx.xxx>:0.0 
```

<xxx.xxx.xxx.xxx> = IP address from desktop
This is the IPv4-address that can be found via internet connection properties.
It is also shown at the top of the SSH session, next to the DISPLAY field.

Check if Xserver-Client is working by starting the xclock application:

```
# xclock
```
 
A clock should appear in a new window.
! if the clock is not appearing, X11 forwarding may be blocked by a firewall. Check settings of firewall and set internet connections to private or allow exceptions.

## Step 8: Install MATLAB  

Use the SSH session in MobaXterm for this step.

Go to the directory where the matlab installer is located :
```
# cd /
# cd matlab
```

Unzip the MATLAB installer:

```
# unzip matlab_R2018a_glnxa64.zip
```

Start MATLAB installation:
```
# ./install
```
An installer screen will pop-up in new window.
! If not, there is a potential problem when firewall is active (see step 7)

In the installer screen, do the following: 

Login to your Mathworks account

Select campus license and proceed

Choose destination folder: /usr/local/MATLAB/R2018a and proceed

Select toolboxes required for compilation and parallelization (Matlab compiler & Parallel computing toolbox), and any other toolboxes that are needed for your analyses and proceed.

When the installer has finished you are ready to start MATLAB.

# Part 2: Running MATLAB on a virtual machine.

When you just finished the Part 1 of this manual you are ready to run MATLAB, and can continue with Part 2: step 2.

## Step 1: start your virtual machine
Each next time you want to start MATLAB on the virtual machine, you need to start up the virtual machine first. You do this by starting a windows command line session.

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

Activate display forwarding with the ```export DISPLAY=``` command (Part 1: step 7).

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
# scp myExecSerial <username>@lisa.surfsara.nl:/home/<username>/
```

For more background on how to transfer data see [Intro SSH & SCP](./ssh.md)

## Step 5: Submit job 

Now start an SSH session to the cluster with MobaXterm.

Create a job submission file:
```
# vim test1
```

Press ```i``` to enter insert mode.

Copy and paste the following text in the editor:

```
UBC
#!/bin/bash
module load mcr/v94
./myExecSerial 200 1
module unload mcr/v94
```
Type ```:wq``` to save and quit.

Now submit the job.

```
# qsub test1
```




see [Introduction to Linux](./Linux_intro.md)
see [Introduction to Docker](./Docker_intro.md)
see [Introduction to HPC](./HPC_intro.md)  
see [Parallelization of MATLAB scripts](./matlab.md)
