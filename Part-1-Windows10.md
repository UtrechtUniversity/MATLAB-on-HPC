# Part 1: Create a Docker container and install Matlab


## Step 1: Install Docker software on PC (Windows 10 Enterprise)

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

In your windows task pane right click on the "Docker Desktop" icon and click settings.

Click the advanced tab.

Under memory: you can change the RAM memory allocated to the virtual machine

Under CPUs: you can change the number of virtual processors.

For example: you can choose for a machine with 3 virtual processors and 3000 MB RAM.
However, which values to choose is limited by your PC. It is recommended not to use all cores of your PC and for RAM memory it is recommended not to use a very large part of the RAM of your system (maximum 60-80%) as it will make normal operations slower (e.g. internet browsing). If your PC becomes much slower, consider changing these values again.

Now click apply settings. 

Docker will indicate that it is restarting.

Wait about a minute until on the right a small screen will appear saying "Docker is now up and Running"

## Step 3: Start working with Docker

Start a Windows Command Prompt session: first click the start button and then type `cmd`.

For some background and basic functions of Windows Command Prompt see [Windows Command Line](https://www.computerhope.com/issues/chusedos.htm)  

Verify that docker is correctly installed and running by typing the following command:

```
> docker version 
```
Version information should be displayed for Docker Client and for Docker Server.

## Step 4: Pull Docker Image

Several Docker Images with different versions of MATLAB have been prepared by UU ITS. Type:

```
> docker search uumatlabinstall
```
to view the the repository.

**IMPORTANT** Before pulling a Docker Image, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster that you will be using (check this using the command: `module avail` at the HPC command line)
>if this is the first time you use Linux or login to a cluster: see [Introduction to Linux](./Linux_intro.md) and [Introduction to HPC](./HPC_intro.md). >The Docker Image should feature the same MATLAB version as one of the mcr versions installed on the HPC system. Check [this website](https://nl.mathworks.com/products/compiler/matlab-runtime.html) to see which MATLAB release links to which version of MCR.

Pull the image that you need by typing e.g.:

```
> docker pull uumatlabinstall/matlab-hpc-compile:<MATLAB version>     (r2016a,r2017b,r2018a_user)
```

( `<MATLAB version>` means you should fill in the MATLAB version of your choice here. These symbols < > will be used more often in this manual when something has to be specified by the user. In this manual we will use version r2018a. If you choose another version you have to change versions each time we specify R2018a in a command.)

If your MATLAB version is _r2018a_, then type at the commandline:

```
> docker pull uumatlabinstall/matlab-hpc-compile:r2018a
```

To build a container yourself instead of pulling this ready to use container you may also follow [this guide](./build_container.md).

## Step 5: Start docker container

When you run a docker container using the `docker run` command, you can select a couple of options. A useful option is to mount a folder from your PC in the docker container. This is useful when you want to transfer files between your docker container and your pc. When you work with cloud storage (Yoda, surfdrive, google drive) you don't need this option (see [data transfer](./Data_transfer.md)). Type the following command to start a docker container WITH a mount of a local folder:

```
> docker run -d -p 22:22 -v /<windows path>:/home/user/mnt --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a
```
Where in the place of <windows path>, you have to type the path to the windows folder, e.g.:

```
> docker run -d -p 22:22 -v /c/Users/ITS/Desktop/testsyncfolder:/home/user/mnt --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a
```
To run a container without a mounted folder type:

```
> docker run -d -p 22:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a     (r2016a,r2017b,r2018a)
```

If an errormessage is displayed saying that "…port is already allocated" choose another port with the following docker command, e.g.:

``` 
docker run -d -p 23:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a     (r2016a,r2017b,r2018a)
```


Verify if the container named matlabuu is running:

```
> docker ps -a
```

You will see a column names and 1 row. The field below STATUS should display something like: Up 10 seconds

## Step 6: start X-server

In order to run MATLAB interactively in your container, you need to install an X11 server. We recommend to install MobaXterm, which is available for free at https://mobaxterm.mobatek.net/. This software is also frequently used for ssh sessions to HPC. 

Download MobaXterm and follow the installation instructions.

Start MobaXterm.

Click the settings icon (or click the settings tab, and click 'Configuration') 

Click the X11 tab.

Set the 'X11 remote access' field to 'full'.

Click OK.

## Step 7: start Docker container

In Windows command prompt, run the following command

`docker exec -it -u user matlabuu bash`

You will see that the prompt changed from something like:

`C:\Users\ITS\>`

to something like: 

`user@fb6123eba838:~$`

This means that from now on you are giving commands to the container (until you exit the container by running the `exit` command). The container is operated with Linux commands instead of Windows commands. For an introduction to Linux commands see [Introduction to Linux](./Linux_intro.md).

>Alternatively it is possible to access your docker container using SSH. For this step you need a Desktop SSH client. For backgrounds of SSH sessions see [SSH & SCP](./ssh.md)  
>Recommended software for SSH is MobaXterm, available at https://mobaxterm.mobatek.net/

>Open MobaXterm  
>Start an SSH session: Click Session > SSH

>Fill in the following fields:   
>Remote host: `< IP – address >`  
>Username: `user`  
>Port: `22` (or 23 if so specified in the previous step)  
>The IP - address that needs to be filled in can be found via windows command line using ```>  docker-machine ls```)  
>Under Bookmark settings, choose a session name (e.g. Docker).

>Click OK to start the session  
>When you are asked for a password, fill in:  
>Password: `user`


## Step 8: Activate display forwarding in Docker container

In your container, give the following command to set the X11 Server display port: 
 
```
# export DISPLAY=<xxx.xxx.xxx.xxx>:0.0 
```

<xxx.xxx.xxx.xxx> = IP address from desktop
This is the IPv4-address that can be found via internet connection properties or via [www.whatsmyip.org](http://www.whatsmyip.org/).

Check if Xserver-Client is working by starting the xclock application:

```
# xclock
```
 
A clock should appear in a new window.
! if the clock is not appearing, X11 forwarding may be blocked by a firewall. Check settings of firewall and set internet connections to private or allow exceptions. If this is not working check the [FAQ](./FAQ.md)

## Step 9: Install MATLAB  

When the xclock successfully appears on your screen, you are ready to start the MATLAB installer.

Go to the directory where the matlab installer is located:
```
$ cd ~
$ cd matlab
```

**IMPORTANT!** 
When you run the following command an installation menu will start. Make sure to follow the installation instructions below during the installation process. It is particularly important to choose the right installation folder and select the right toolboxes.

Run MATLAB installation script:
```
$ sudo ./install_matlab.sh
```
An installer screen will pop-up in a new window.
! If not, there is a potential problem when firewall is active (see previous step or [FAQ](./FAQ.md)).

In the installer screen, do the following: 

Login to your Mathworks account

Select campus license and proceed

**Choose installation folder: /opt/matlab** 

**Select toolboxes required for compilation and parallelization (Matlab compiler & Parallel computing toolbox), and any other toolboxes that are needed for your analyses and proceed.**

When the installer has finished, you will be asked if you want to activate matlab now. Activate matlab.

When you have finished the activation procedure, you are ready to start MATLAB.


If you want to proceed with using MATLAB: go to [part 2](./Part-2-running-matlab.md)


## Starting and ending a Docker session 

Here are some useful commands for ending and starting docker sessions, e.g. when you want to stop here and proceed with part 2 another time:

**Ending a session:**

Exit your Docker container by typing ```$ exit``` and press return.

To end the running container type in Windows Command Prompt:
```
> docker stop <container name>
```
e.g.
```
> docker stop matlabuu

```
Now stop docker software and the virtual machine:

Go to the "Docker for Windows" Icon in your Windows taskbar.
 
Right-click on the Icon.
 
A menu appears, click on "Quit Docker"

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


Continue with [part 2](./Part-2-running-matlab.md)

## Links

[Introduction to Linux](./Linux_intro.md)  
[Introduction to Docker](./Docker_intro.md)  
[Introduction to HPC](./HPC_intro.md)  
[Introduction to SSH & SCP](./ssh.md)  
[Transferring your data](Data_transfer.md)  
[Part 3: Parallelization of MATLAB scripts](./matlab.md)  
[MATLAB Test script 1](./Test_1.m)  
[FAQ](./FAQ.md)  

