
## Step 1: Make a new directory on your local computer e.g. by using windows explorer

In windows, choose a location: e.g. the Documents folder and make a new directory. 

E.g.: matlabjt

Next use [Windows command line](./CMD.md) to navigate to this folder using the following commands: 

```
> dir 			      to see folders in current directory
> cd .. 			    to go up one folder
> cd <folder> 		to add folder (must be in current directory) to path
```

Example path: c/Users/<username>/Documents/matlabjt

## Step 2: Make a file named: Dockerfile

Using notepad, make a file with the following content and save it as ```"Dockerfile"``` (!use the quotation marks to save without a file extension) in the folder you created. 

```
FROM ubuntu:16.04
RUN apt-get update && apt-get install -y openssh-server
RUN apt-get update && apt-get install -y vim
RUN apt-get install –y unzip
RUN apt-get install –y xorg
RUN mkdir /var/run/sshd
RUN echo 'root:wijzigen' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```
Note:
This Dockerfile is used to create an Ubuntu 16.04 image with ssh access, and the following programs installed: vim, unzip and xorg.
Ubuntu login: "Root" password: "wijzigen".

## Step 3: Make a Docker image named: ubuntu_uu_sshd

Use Windows command line for this step

!!!! werkt het docker build command dan wel vanaf command line????
Make sure you are in the directory where the “Dockerfile” is located.
 
Type the following docker command and press enter.
 !!!!!!!!!!!!
$ docker build -t ubuntu_jt_sshd .  	(note: the . is part of the command)
 
Check if the produced image is there:

	$ docker images
	
	Start a container named matlabjt:

$ docker run -d -p 23:22  --name matlabjt ubuntu_jt_sshd
 
Verify if the container named matlabjt is running:

$ docker ps

Step 7: Start SSH session to Docker container (user: root)

For this step you need a Desktop SSH client.

Recommended MobaXterm, available at https://mobaxterm.mobatek.net/

Open MobaXterm
Start an SSH session: MobaXterm > Session > SSH

Remote host: < IP – address >      	(this can be found in the Docker quickstart terminal using 

$  docker-machine ls

Username: root   		(or other as defined in step 4)
Password: wijzigen		(or other as defined in step 4)
Port: 22 or 23 (see step 6, you need the first port 22:22)


##Step 8: Install and verify X11 Server software in the Docker container

Use the SSH session in MobaXterm for this step
 
Set X11 Server display port: 

# export DISPLAY=<xxx.xxx.xxx.xxx>:0.0 

<xxx.xxx.xxx.xxx> = IP address from desktop
This is the IPv4-address that can be found via internet connection properties
Check if Xserver-Client is working by starting the xclock application:

# xclock
 
… A clock should appear in your screen …
! if the clock is not appearing, X11 forwarding may be blocked by a firewall. Check settings of firewall and allow exceptions.


 
##Step 9: Download Linux MATLAB installation software including compiler toolbox from Mathworks using UU-license.

Before downloading, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster (check this using the module avail command). The local MATLAB installation should be the same version as one of the mcr versions installed on the HPC system. Download a MATLAB Linux installer (e.g. for the UBC cluster 2018a, for  LISA 2016a, 2016b, 2017 b) from https://mathworks.com using your mathworks account and linked UU campus license. For instructions on linking the campus license to your mathworks account visit: https://students.uu.nl/en/free-software.

Save the installer file (e.g. matlab_R2018a_glnxa64.zip) on your computer in the folder from step 3.

##Step 10: copy the Linux MATLAB installer to the running Docker container

	Use the Docker Quickstart Terminal for this step.

Make sure you are in the directory of the matlab installer file (using >pwd and >ls).
 
Copy the file to the (running) matlabjt container:

$ docker cp matlab_R2018a_glnxa64.zip matlabjt:matlab_R2018a_glnxa64.zip


##Step 11: Move the MATLAB installer

Use the SSH session in MobaXterm for this step.

Check whether the installer file is in the container: 
```
# ls / -al
```
Go to root directory:
```
# cd /
```
Make a new directory, e.g. /matlab:
```
# mkdir matlab
```
Go to the new directory:
```
# cd matlab
```
Move the MATLAB installer to the current directory:
```
# mv /matlab_R2018a_glnxa64.zip /matlab
