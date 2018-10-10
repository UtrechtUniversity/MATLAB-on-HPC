# Part 1: Create a Docker container and install Matlab


## Step 1: Install Docker software on PC (Windows 10 Pro)

Download Docker Community Edition for Windows via:

https://www.docker.com/get-started

Click on "Download for Windows"

Click on "Please Login to Download"

Login or create an account first

Click on "Get Docker" and the download will start.

Open the downloaded installer file: "Docker for Windows Installer.exe"

Confirm that as part of the installation process, the app may make changes to the device.

… proceed with the installation …

Only select "add shortcut to desktop".

**Important** Unselect the other installation option

Close the installation screen when completed (without errors).

Now double click on the "Docker for Windows" icon on your desktop. Docker will start.
If so requested by windows: Enable Hyper-V and restart your computer.

Double click on the "Docker for Windows" icon on your desktop. Docker will start.

Wait about a minute until on the right a small screen will appear saying "Docker is now up and Running"
Close this screen by clicking on the "X".

## Step 2: Change virtual machine settings

In windows go to Start Menu and start "Hyper-V Manager"

In the pane on the left of Hyper-V Manager, there should be 1 item below Hyper-V Manager: click this item.

Now in the middle pane, under Virtual Machines: there should be 1 virtual machine listed with State: running.

We will change some of the settings of this virtual machine, but before we do this we have to shut down the machine.

Right click on the virtual machine and select: Shut Down

Right click on the virtual machine and select: Settings

A new window appears. 

Under memory: you can change the RAM memory allocated to the virtual machine

Under Processors: you can change the number of virtual processors.

For example: you can choose for a machine with 3 virtual processors and 3000 MB RAM.
However, which values to choose is limited by your PC. It is recommended not to use all cores of your PC and for RAM memory it is recommended not to use a very large part of the RAM of your system (maximum 60-80%) as it will make normal operations slower (e.g. internet browsing). If your PC becomes much slower, consider changing these values again.

## Step 3: Start working with Docker

Start a Windows Command Prompt session by typing `cmd` in the windows start menu search field.

For some background and basic functions of Windows Command Prompt see [Windows Command Line](https://www.computerhope.com/issues/chusedos.htm)  

Verify that docker is correctly installed and running by typing the following command:

```
> docker version 
```
Version information should be displayed for Docker Client and for Docker Server.

## Step 4: Pull Docker Image

Several Docker Images with different versions of MATLAB have been prepared by UU ITS. For an overview, type:

```
> docker search uumatlabinstall
```

**IMPORTANT** Before pulling a Docker Image, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster that you will be using (check this using the module avail command (if this is the first time you use Linux or login to a cluster: see [Introduction to Linux](./Linux_intro.md) and [Introduction to HPC](./HPC_intro.md)). The Docker Image should feature the same MATLAB version as one of the mcr versions installed on the HPC system. Check [this website](https://nl.mathworks.com/products/compiler/matlab-runtime.html) to see which MATLAB release links to which version of MCR.

Pull the image that you need by typing e.g.:

```
> docker pull uumatlabinstall/matlab-hpc-compile:<MATLAB version>     (r2016a,r2017b,r2018a)
```
(<MATLAB version> means you should fill in the MATLAB version of your choice here. These symbols < > will be used more often in this manual when something has to be specified by the user)

To build a container yourself instead of pulling this ready to use container you may also follow [this guide](./build_container.md).

## Step 5: Start docker container

Type the following command to start a docker container:

```
> docker run -d -p 22:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:<MATLAB version>     (r2016a,r2017b,r2018a)
```

If an errormessage is displayed saying that "…port is already allocated" choose another port with the following docker command, e.g.:

``` 
docker run -d -p 23:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:<MATLAB version>     (r2016a,r2017b,r2018a)
```


Verify if the container named matlabuu is running:

```
> docker ps -a
```

## Step 6: Start SSH session to Docker container (user: root)

For this step you need a Desktop SSH client. For backgrounds of SSH sessions see [SSH & SCP](./ssh.md)  

Recommended software for SSH is MobaXterm, available at https://mobaxterm.mobatek.net/

Open MobaXterm
Start an SSH session: Click Session > SSH

Fill in the following fields:  
Remote host: `localhost`  
Username: `root`  
Port: `22` (or 23 if so specified in the previous step)  

Under Bookmark settings, choose a session name (e.g. Docker).

Click OK to start the session  
When you are asked for a password, fill in:  
Password: `wijzigen`


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



If you want to proceed with using MATLAB: go to [part 2](./Part-2-running-matlab.md)


## Starting and ending a Docker session 

Here are some useful commands for ending and starting docker sessions, e.g. when you want to stop here and proceed with part 2 another time:

**Ending a session:**

End your ssh session to the Docker container in MobaXterm by typing ```# exit``` and press return.

To end the running container type in Windows Command Prompt:
```
> docker stop <container name>
```
e.g.
```
> docker stop matlabuu

```
To stop the virtual machine, go to the start menu and start Hyper-V manager.
Right click the virtual machine in the left pane and click: Shut Down.



**Starting a session:**

Double click on the "Docker for Windows" icon on your desktop.

Now start Windows Command Prompt.

Verify that docker is correctly installed and running by typing the following command:

```
> docker version 
```
Version information should be displayed for Docker Client and for Docker Server.

Next start the container by typing:

`docker start <container name>`	

You can use the following command to see if the container is stopped or started: 

```
docker ps -a
```
More information about Docker and Docker commands can be found [here](./Docker_intro.md) or in the official [Docker documentation](https://docs.docker.com/).

## Links

[Introduction to Linux](./Linux_intro.md)  
[Introduction to Docker](./Docker_intro.md)  
[Introduction to HPC](./HPC_intro.md)  
[Intro SSH & SCP](./ssh.md)  
[Parallelization of MATLAB scripts](./matlab.md)  
[MATLAB Test script 1](./Test_1.m)  

