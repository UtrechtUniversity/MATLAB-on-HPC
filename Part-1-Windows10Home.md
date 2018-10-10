# Part 1: Create a Docker container and install Matlab


## Step 1: Install Docker software on PC (Windows 10 Home)

Download Docker Toolbox via:   
https://docs.docker.com/toolbox/toolbox_install_windows/

Double-click the Docker for Windows Installer to run the installer.

## Step 2: Start Docker software

Start a Windows Command Prompt session by typing `cmd` in the windows start menu search field.

For some background and basic functions of Windows Command Prompt see [Windows Command Line](https://www.computerhope.com/issues/chusedos.htm)  

Navigate to the directory where Docker is installed.

e.g.

```
...> cd /
C:\> cd Program Files/Docker Toolbox
```
## Step 3: Create a virtual machine

Now you will create a virtual machine with the name ‘default’. The example below has 3 cores  (–virtualbox-cpu-count 3), a storage disk with 100 GB storage (--virtualbox-disk-size "100000") and 3 GB RAM (--virtualbox-memory 3000). These values can be adapted if required. As you reserve part of your working station for this virtual machine, by definition these values cannot be higher than what is available on your PC. It is advised not to choose these values too high; too much RAM may slow down your working station. 

Type the following command:
```
> docker-machine create -d virtualbox –virtualbox-cpu-count 3 --virtualbox-disk-size "100000" --virtualbox-memory 3000 default
```
Now we have a new virtual machine with the name default.

Verify that docker is correctly installed and running by typing the following command:

```
> docker version 
```
Version information should be displayed for Docker Client and for Docker Server.

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

**IMPORTANT** Before pulling a Docker Image, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster that you will be using (check this using the module avail command (if this is the first time you use Linux or login to a cluster: see [Introduction to Linux](./Linux_intro.md) and [Introduction to HPC](./HPC_intro.md)). The Docker Image should feature the same MATLAB version as one of the mcr versions installed on the HPC system. Check [this website](https://nl.mathworks.com/products/compiler/matlab-runtime.html) to see which MATLAB release links to which version of MCR.

Pull the image that you need by typing e.g.:

```
> docker pull uumatlabinstall/matlab-hpc-compile:<MATLAB version>     (r2016a,r2017b,r2018a)
```

To build a container yourself instead of pulling this ready to use container you may also follow [this guide](./build_container.md).

## Step 5: Start docker container

Type the following command to start a docker container:

```
> docker run -d -p 23:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a
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
Remote host: `< IP – address >`        	
Username: `root`       	
Port: `23`     
The IP - address that needs to be filled in can be found via windows command line using ```>  docker-machine ls```)

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
To stop the virtual machine, type:
```
> docker-machine stop default
```


**Starting a session:**

To start a session start Windows command prompt and type:
```
> docker-machine start default
```
Now wait a while for the the virtual machine to start.

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

