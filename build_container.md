
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

## Step 3: Make a Docker container

Use Windows command line for this step

Make sure you are in the directory where the “Dockerfile” is located.
 
Choose a name for the docker image and type the following docker command (replace ubuntu_uu_sshd with your container name or use ubuntu_uu_sshd as below):

```
> docker build -t ubuntu_uu_sshd .  	(note: the . is part of the command)
```
Check if the produced image is there:

```
> docker images
```
Build a container named matlabuu:

```
> docker run -d -p 23:22  --name matlabuu ubuntu_jt_sshd
```
Verify if the container named matlabuu is running:

```
> docker ps
```

## Step 4: Download Linux MATLAB installer from Mathworks using UU-license.

Before downloading, make sure which version of MATLAB compiler runtime (MCR) is available on the cluster (check this using the module avail command). The local MATLAB installation should be the same version as one of the mcr versions installed on the HPC system. Download a MATLAB Linux installer (e.g. for the UBC cluster 2018a, for  LISA 2016a, 2016b, 2017b) from https://mathworks.com using your mathworks account and linked UU campus license. For instructions on linking the campus license to your mathworks account visit: https://students.uu.nl/en/free-software.

Save the installer file (e.g. matlab_R2018a_glnxa64.zip) on your computer in the newly created folder from step 1.

## Step 5: copy the Linux MATLAB installer to the running Docker container

Make sure you are in the directory of the matlab installer file (using >dir).
 
Copy the file to the (running) matlabjt container:

```
> docker cp matlab_R2018a_glnxa64.zip matlabuu:matlab_R2018a_glnxa64.zip
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

##Step 7: Move the MATLAB installer

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
```

To install MATLAB continue with [Part 1: Step 7](./Part-1-preparation.md)

