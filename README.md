---
output:
  pdf_document: default
  html_document: default
---
# MATLAB-on-HPC
Tools and instructions for developing and running MATLAB scripts on HPC clusters

# Introduction

# Install Docker

## Step 1: Install Docker software on PC (Windows 10 Pro)

Download Docker Community Edition (CE) via:  
https://store.docker.com/editions/community/docker-ce-desktop-windows

Double-click the Docker for Windows Installer to run the installer

Note: if you get the following error: Installation failed: one pre-requisite is not fulfilled, you may have a different Windows edition. Required Windows 10 Pro.  

Option 1: Recommended by Docker: Upgrade to Windows 10 **Pro**: Costs for updating to without a license: 145 euro 

Option 2: Install Docker Toolbox (see step 1c).

To check which Windows version you have: press Windows key + I > system > about

## Step 1b: Install Docker software on PC (mac)

Download Docker Community Edition (CE) via:   
https://store.docker.com/editions/community/docker-ce-desktop-mac

## Step 1c: Install Docker software on PC (Windows 10 Home)

Download Docker Toolbox via:   
https://docs.docker.com/toolbox/toolbox_install_windows/

Double-click the Docker for Windows Installer to run the installer.

## Step 2: Start Docker software

Start a command line session
In windows, in the search field next to the start button, type cmd and open command prompt

Type the following command:
```
$ docker version 
```
Information should be displayed for Docker Client and for Docker Server.



# Install MATLAB

see [Introduction to Linux](./Linux_intro.md)
see [Introduction to HPC](./HPC_intro.md)
see [SSH & SCP](./ssh.md)
see [Parallelization of MATLAB scripts](./matlab.md)
