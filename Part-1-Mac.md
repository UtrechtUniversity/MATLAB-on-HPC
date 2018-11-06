
# Part 1: Create a Docker container and install Matlab


### Step 1: Install Docker software on Apple Mac OS (Yosemite 10.10.3 or above)

Download Docker Community Edition for Mac via:

https://www.docker.com/get-started

Click on "Download for Mac"

Click on "Please Login to Download"

Login (or create an account first)

Click on "Get Docker" and the download will start.

Open the downloaded .dmg file and move Docker icon  to Applications icon

Go to Applications in the Finder and open the Docker application

Docker wants priviliged access to install components; you wil be asked for your system password

Wait a few seconds until a small screen will appear saying "Docker is now up and Running"

Close this screen by clicking on the "X". 

If you have a Docker account you can login but this is not required.

### Step 2: Change Docker settings

Go to the *Docker Icon* in the taskbar. Select Preferences -> Advanced. Here you can specify the number of processors (CPUs) and working memory (RAM) resources that are available for Docker to use. To test parallel matlab programs in the Docker environment we advise to assign at least 2 cores and 2 GB RAM. To create a more powerful 'virtual machine' you can increase these values, but it is advisable to reserve some CPUs (e.g. 2) and memory (e.g. 4 GB) for other computer tasks that you perform while running docker.

If either your PC or running Matlab inside Docker becomes too slow, consider changing these values.

Apply changes and start Docker again.
After a while you get the message "Docker is Running". Close the Preferences pop-up window

### Step 3: Start working with Docker

Start a terminal session by selecting the app Terminal in the Applications folder or in the Dock.

For an introduction of the basic functions of Terminal click [here](https://macpaw.com/how-to/use-terminal-on-mac).

Verify that docker is correctly installed and running by typing the following command:

```
> docker --version 
```
Version information should be displayed

Several Docker Images with different versions of MATLAB have been prepared by UU ITS. For an overview, type:

```
> docker search uumatlabinstall
```

If you see a list of three repositories your system is OK.

### Step 4: Pull Docker Image

**IMPORTANT** Before pulling a Docker Image, make sure which version of the MATLAB compiler runtime (MCR) is available on the cluster that you will be using. Check this using the `module avail mcr` command.

>*If this is the first time you use Linux or login to a cluster: see [Introduction to Linux](./Linux_intro.md) and [Introduction to HPC](./HPC_intro.md).*
>*The Docker Image should feature the same MATLAB version as one of the MCR versions installed on the HPC system. Check [this website](https://nl.mathworks.com/products/compiler/matlab-runtime.html) to see which MATLAB release links to which version of MCR.*

Pull the image that you need by typing e.g.:

```
> docker pull uumatlabinstall/matlab-hpc-compile:<MATLAB version>    (r2016a,r2017b,r2018a)
```
If your MATLAB version is _r2018a_, then type at the commandline:

```
> docker pull uumatlabinstall/matlab-hpc-compile:r2018a
```
In this manual we will use version r2018a. If you choose another version you have to change versions each time we specify r2018a in a command.

To build a container yourself instead of pulling this ready to use container you may also follow [this guide](./build_container.md).

### Step 5: Start docker container

Type the following command to start a docker container:

```
> docker run -d -p 22:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a
```

If an errormessage is displayed saying that "…port is already allocated" choose another port with the following docker command, e.g.:

``` 
docker run -d -p 23:22 --name matlabuu uumatlabinstall/matlab-hpc-compile:r2018a
```

Verify if the container named matlabuu is running:

```
> docker ps -a
```

### Step 6: Start SSH session to Docker container (user: root)

In **Terminal** type:

```
ssh root@localhost
```

If you used port 23 (or any other number) instead of 22 in the previous step (so the first port is not 22: ), you have to specify the port number. E.g.

```
ssh -p 23 root@localhost
```

> For backgrounds to SSH sessions see [SSH & SCP](./ssh.md)  

The first time you login you will be asked to accept the 'fingerprint' of the docker container. Type `yes` and the fingerprint will be checked in subsequent login sessions.

Then you are asked for a password, fill in `wijzigen`. You will see the commandline prompt of the docker container which runs a Linux operating system.

This password is also a reminder to change the password (`wijzigen` is the Dutch word for `change`)

Think of a good password and type at the command prompt `passwd`. Type and retype your new password.


### Step 7: Activate display forwarding in Docker container

To use GUI (graphical user interface) applications, your docker containter has to communicate with your mac by means of the X11 protocol. On macOS you have to install [XQuartz](https://www.xquartz.org) to allow display forwarding. 

Open a separate `Terminal` session. 

Make sure that the file `/etc/ssh/sshd_config` contains the line `X11Forwarding yes`.

In the Terminal type:
```
cd /etc/ssh
```
Then open the `sshd_config` file.

Make sure that the file contains the line: `X11Forwarding yes`.

If not there may be a line like this:

```#X11Forwarding no```

If that is the case, remove the `#` and change `no` to  `yes`.

Save and close the file.

If you didn't need to change the file you can close the separate Terminal session and go back to the SSH session.

If you had to make changes to the `sshd_config` file, you have to restart your ssh daemon on your mac.
Do this by running the following commands in the Terminal.

```
sudo launchctl stop com.openssh.sshd
sudo launchctl start com.openssh.sshd
```
Now you can close the separate Terminal session and go back to the SSH session.

In the SSH session to the docker container in the Terminal, set the DISPLAY variable with your internet IP address followed by `:0.0`. E.g.

```
# export DISPLAY=145.107.146.50:0.0 
```

This is the IPv4-address that can be found in *Preferences --> Network --> Advanced --> TCP/IP*. Or look it upin with [your browser](https://whatismyipaddress.com).

Check if Xserver-Client is working by starting the xclock application:

```
# xclock
```
 
A clock should appear in a new window on the display of your mac.

## Step 8: Install MATLAB  

In the SSH session to the docker container in the Terminal, go to the directory where the matlab installer is located

```
# cd /
# cd matlab
```

Unzip the MATLAB installer:

```
# unzip matlab_R2018a_glnxa64.zip
```

Start MATLAB installation

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

To end the running container type at the macOS prompt:

```
> docker stop matlabuu
```

or, if your container has another name, substitute `matlab` with that name 

Now you can stop the docker software bij clicking the Docker icon in the menubar and selecting `Quit Docker`. But it doesn't harm when you let the Docker running.
 

**Starting a session:**

If Docker isn't running, start the program from your Aplications folder or from your Dock

Verify that docker is correctly installed and running by typing the following command at the Terminal prompt:

```
> docker version 
```

Next start the container by typing:

```
docker start matlabuu
```

You can use the following command to see if the container has stopped/started: 

```
docker ps -a
```

More information about Docker and Docker commands can be found [here](./Docker_intro.md) or in the official [Docker documentation](https://docs.docker.com/).


Continue with [part 2: Running Matlab](./Part-2-running-matlab.md)

## Useful Links

[Introduction to Linux](./Linux_intro.md)  
[Introduction to Docker](./Docker_intro.md)  
[Introduction to HPC](./HPC_intro.md)  
[Intro SSH & SCP](./ssh.md)  
[Part 3: Parallelization of MATLAB scripts](./matlab.md)  
[MATLAB Test script 1](./Test_1.m)  

