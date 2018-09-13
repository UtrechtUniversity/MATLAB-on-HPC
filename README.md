---
output:
  pdf_document: default
  html_document: default
---
# MATLAB-on-HPC
Tools and instructions for developing and running MATLAB scripts on HPC clusters

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


# Install MATLAB  

see [Introduction to Linux](./Linux_intro.md)  
see [Introduction to HPC](./HPC_intro.md)  
see [SSH & SCP](./ssh.md)  
see [Parallelization of MATLAB scripts](./matlab.md)
