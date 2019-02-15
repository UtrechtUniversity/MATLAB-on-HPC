# Build a docker container with Ubuntu and MATLAB installer


## Step 1: Make a new directory on your local computer e.g. by using windows explorer

In windows, choose a location: e.g. the Documents folder and make a new directory. 

E.g.: matlabuu

Next use [Windows command line](./CMD.md) to navigate to this folder using the following commands: 

```
> dir 			      to see folders in current directory
> cd .. 			    to go up one folder
> cd <folder> 		to add folder (must be in current directory) to path
```

Example path: c/Users/<username>/Documents/matlabuu

## Step 2: Download Linux MATLAB installer from Mathworks using UU-license.

Before downloading, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster (check this using the module avail command). The local MATLAB installation should be the same version as one of the mcr versions installed on the HPC system. Download a MATLAB Linux installer (e.g. for the UBC cluster 2018a, for  LISA 2016a, 2016b, 2017b) from https://mathworks.com using your mathworks account and linked UU campus license. For instructions on linking the campus license to your mathworks account visit: https://students.uu.nl/en/free-software.

Save the installer file (e.g. matlab_R2018a_glnxa64.zip) on your computer in the newly created folder from step 1.


## Step 3: Download Dockerfile

Download the Dockerfile in this github repository to the folder created in step 1.  

>Alternatively, make a Dockerfile yourself using notepad with the following content and save it as ```"Dockerfile"``` (!use the quotation marks to save without a file extension) in the folder you created. 

```
FROM ubuntu:16.04

# install software
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        -y openssh-server \
        -y vim \
        -y unzip \
        -y xorg \
		-y libfuse2 \
		-y cifs-utils \
		-y wget libcurl4-gnutls-dev \
	-y net-tools \
	-y sudo

# allow root login 
RUN echo 'root:wijzigen' | chpasswd

# setup and ssh server
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22

# add user profile
ENV user user
RUN useradd --create-home --shell /bin/bash ${user} 
WORKDIR /home/${user} 
RUN echo 'user:user' | chpasswd
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# create matlab folder with matlab installer
RUN mkdir /home/user/matlab 
COPY matlab_R2018a_glnxa64.zip /home/user/matlab
RUN cd /home/user/matlab \
 && unzip matlab_R2018a_glnxa64.zip \
 && chown -R user /home/user
COPY install_matlab.sh /home/user/matlab
RUN chown root:root /home/user/matlab/install_matlab.sh \
 && chmod o=rx /home/user/matlab/install_matlab.sh

# install icommands
RUN wget https://files.renci.org/pub/irods/releases/4.1.12/ubuntu14/irods-icommands-4.1.12-ubuntu14-x86_64.deb -O /tmp/icommands.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y `dpkg -I /tmp/icommands.deb | sed -n 's/^ Depends: //p' | sed 's/,//g'`
RUN dpkg -i /tmp/icommands.deb \
 && rm /tmp/icommands.deb
RUN mkdir /home/user/.irods \
 && chown user:user /home/user/.irods \
 && chmod +w /home/user/.irods
 
# create folder for mounting local folder
RUN mkdir /home/user/mnt

# give sudo rights for installer file
RUN echo "${user} ALL=(ALL:ALL) NOPASSWD: /home/user/matlab/install_matlab.sh" >> /etc/sudoers

# expose irods port
EXPOSE 1247

# run command at startup
CMD ["/usr/sbin/sshd", "-D"]

```
**Note:**
This Dockerfile is used to create an Ubuntu 16.04 image with ssh access, and the following programs installed: vim, unzip and xorg.
Ubuntu login: "Root" password: "wijzigen".
It also puts the matlab installer in the container. In the dockerfile contents change the matlab version if you downloaded an installer that is not 2018a.
If you get an error in the COPY step, it is also possible to transfer files manually (see: Optional step 5). In that case you can remove these lines:

```
RUN mkdir /matlab
COPY matlab_R2018a_glnxa64.zip /matlab
```
## Step 4: Download install_matlab.sh

Download the script install_matlab.sh in this github repository to the folder created in step 1.  

## Step 5: Make a Docker container

Use Windows command line for this step

Make sure you are in the directory where the “Dockerfile” is located.
 
Choose a name for the docker image and type the following docker command (replace `docker_matlab` with any image name or use `docker_matlab` as below):

```
> docker build -t docker_matlab .  	(note: the . is part of the command)
```
Check if the produced image is there:

```
> docker images
```
Build a container named matlabuu:

```
> docker run -d -p 22:22 --name matlabuu docker_matlab
```
Or use port 23 if you have Windows 10 **Home** edition or older versions of Windows. This could also be a solution if port 22 is in use by a different process.

```
> docker run -d -p 23:22 --name matlabuu docker_matlab
```

Verify if the container named matlabuu is running:

```
> docker ps
```

## Optional step 6: copying the Linux MATLAB installer to the running Docker container manually

Only perform this step when you removed the copy command from the Dockerfile.

In your Windows command prompt session, make sure you are in the directory of the matlab installer file (using `dir` and `cd` commands).
 
Copy the file to the (running) container:

```
> docker cp matlab_R2018a_glnxa64.zip matlabuu:matlab_R2018a_glnxa64.zip
```

## Step 7: start X-server

In order to run MATLAB interactively in your container, you need to install an X11 server. We recommend to install MobaXterm, which is available for free at https://mobaxterm.mobatek.net/. This software is also frequently used for ssh sessions to HPC. 

Download MobaXterm and follow the installation instructions.

Start MobaXterm.

Click the settings icon (or click the settings tab, and click 'Configuration') 

Click the X11 tab.

Set the 'X11 remote access' field to 'full'.

Click OK.

## Step 8: start Docker container

In Windows command prompt, run the following command

`docker exec -it -u user matlabuu bash`

You will see that the prompt changed from:

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


## Step 8: Moving and editing files

When in an SSH session in MobaXterm it is possible to move and edit files and folders using Linux commands, see this [manual](./Linux_intro).

To install MATLAB continue with [Part 1: Step 8](./Part-1-preparation.md)


