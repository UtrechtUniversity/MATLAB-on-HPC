# Why Docker?

Current HPC workflowsfor MATLAB -at Surfsara and UBC- require MATLAB code to be compiled to machine language and submitted as a job on HPC systems. The compilation of MATLAB code has to be done on a Linux system, to be able to execute it on HPC. For researchers that don't have a Linux PC (but Windows or MAC), a Docker container is a simple solution to run a Linux version of MATLAB on the local PC. 

It is also possible to compile code on LISA (where matlab is installed) and on UBC (where matlab can be installed by the user). However, there are limitations to using MATLAB on the cluster as login nodes should only be used for small tasks, not for large test runs.  
Depending on the situation (number of interlinked scripts, amount of input data, necessity to test and debug code), a Docker container is in most cases probably a much more flexible way to do your work.  

How does it work? In short you create a virtual machine on your PC and run a Linux container on this machine. Here you install a Linux version of MATLAB. On this virtual machine you have some storage where you can tranfer your data and your scripts to. On the virtual machine you test, debug and compile MATLAB code. The compiled code can be sent to the cluster directly.

This page describes the required software, the architecture of Docker and a list of useful commands. In general the [Documentation](https://docs.docker.com/) on the Docker website is very good. This page is aimed to give a short overview of the most relevant information.

## Versions

Different versions of Docker software exist for different operating systems.

The newest version for windows works only on Windows 10 **PRO** and is called Docker Community Edition (CE):
https://store.docker.com/editions/community/docker-ce-desktop-windows

On older versions of Windows and Windows 10 **HOME** it is possible to use Docker Toolbox:
https://docs.docker.com/toolbox/toolbox_install_windows/

Docker Community Edition is also available for mac:   
https://store.docker.com/editions/community/docker-ce-desktop-mac

In general each version works similar, but there are some differences: e.g. the software that is used to create virtual machines on Windows 10 PRO (Hyper V) is not available on Windows 10 HOME. On Windows 10 HOME Oracle VM VirtualBox is used. 
This also has some consequences for the commands to use to create a virtual machine as well as which port to assign when starting a container

## Operating Docker

We recommend operating Docker via Windows Command Prompt (although there are multiple options, including  Docker Quickstart Terminal that comes with installation of Docker Toolbox for Windows 10 HOME).
You need minimal knowledge of Windows Command Prompt commands to operate Docker. See this [tutorial](https://www.computerhope.com/issues/chusedos.htm) for the most important commands.

Navigate to the Docker folder e.g. using the following commands:
```
cd /
cd Program Files
cd Docker Toolbox
dir
```
If everything went correct, you will see a list of files and folders including `docker.exe` and `docker-machine.exe`.

Here you can create and remove virtual machines, turn virtual machines on and off, create or import Docker images and run Docker containers.


### Virtual machines

Depending on your version, upon installation of Docker software a machine called 'default' will be created. This default machine has a certain number of cores (CPUs), memory size (RAM) and storage size.

To check if there already exists a virtual machine on you PC, type:

`docker-machine ls`

If a virtual machine exists, you will see something like this:

```
NAME      ACTIVE  DRIVER       STATE     URL   SWARM   DOCKER    ERRORS  
default   -       virtualbox   Stopped                 Unknown
```

If you have used Docker before you may have more machines listed here.

We recommend creating an as clean as possible workflow to reduce potential sources of errors. Therefore we recommend having only one default machine (that has enough storage and RAM to run MATLAB smoothly and that has more than 1 CPUs to be able to test parallel commands), and removing all other machines.  

On Windows 10 PRO the 'default' machine is created by Hyper V which is installed in Windows by default. Here it is possible to change the characteristics of a machine manually: see the Docker Settings dialog part on [this page](https://docs.docker.com/docker-for-windows/#advanced).
To create a virtual machine from command line see [this page](https://docs.docker.com/machine/drivers/hyper-v/#2-set-up-a-new-external-network-switch-optional).

On Windows 10 HOME Hyper V is not available. Here, the 'default' machine is created by Oracle VirtualBox VM, which comes with the Docker Toolbox Installation. In contrary to the Windows 10 PRO workflow, here it is not possible to manually change all characteristics of the machine. So we have to remove the default machine (which is too small for MATLAB) and create a new default machine that fullfills all needs for running MATLAB. This can be done using command line, see [this page](https://docs.docker.com/machine/drivers/virtualbox/) for all options. 

Removing a virtual machine named `default` is done with the following command:

`docker-machine rm default`

As mentioned above we recommend working with only 1 virtual machine and removing all others. If you want to preserve virtual machines, you can create a new one and turn machines on and off to switch between them.

You can start the machine by typing:

`docker-machine start default`

If the STATE of the machine is Running you can stop the machine by typing:

`docker-machine stop default`

When switching between machines you need to run 2 commands after the `docker-machine start` command for switching the 'environment':

```
docker-machine start default
docker-machine env default
@FOR /f "tokens=*" %i IN ('docker-machine env default') DO @%i
```
(these commands will also be displayed when running the `docker-machine start` and `docker-machine env` commands).

Another useful command to resolve errors is a command to update the 'TLS certificates'
This may be needed when a new IP address is assigned to a virtual machine, and you receive an error. 

`docker-machine --debug regenerate-certs -f default`

### Docker architecture
For a full introduction, the user is referred to the website of Docker. The [Overview](https://docs.docker.com/engine/docker-overview/) page gives an overview of the architecture of Docker. The [Getting started](https://docs.docker.com/get-started/) page gives instructions of how to create docker images and containers. Only Part 1 and 2 of the Getting started pages are really relevant for our aims.

There are two terms that we use a lot when talking about Docker: 'Docker Image' and 'Docker Container'.
The [Overview](https://docs.docker.com/engine/docker-overview/) page of Docker gives good definitions of these terms.

**Docker Image**  
*"An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization. For example, you may build an image which is based on the ubuntu image, but installs the Apache web server and your application, as well as the configuration details needed to make your application run.*

*You might create your own images or you might only use those created by others and published in a registry. To build your own image, you create a Dockerfile with a simple syntax for defining the steps needed to create the image and run it. Each instruction in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild the image, only those layers which have changed are rebuilt. This is part of what makes images so lightweight, small, and fast, when compared to other virtualization technologies."*

To create an image you need to create a file with the name 'Dockerfile' with instructions. [This page](https://docs.docker.com/engine/reference/builder/#usage) gives information about the contents of a dockerfile. An example of a Dockerfile is given [here](./build_container).

You need to create a folder where you want to build the image and save the Dockerfile there. With Windows Command Prompt, navigate to this folder and create an image from the Dockerfile by using the `docker build` command:

`docker build -t <image name> . ` *(note: the . is part of the command)*

It is also possible to load images from an online repository with the `docker pull` command. See below for further explanation of repositories.

Useful other commands:

To list all images:
`docker image ls -a`

Remove images
`docker image rm <image name>`

To further clean up your docker session. E.g. when you keep running into errors, it may be wise to erase remaining data of old images with the following commands:

`docker system prune`		(remove unused images)
`docker system prune -a` 	(remove archived images)


**Docker Container**  
*"A container is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI. You can connect a container to one or more networks, attach storage to it, or even create a new image based on its current state.*

*By default, a container is relatively well isolated from other containers and its host machine. You can control how isolated a container’s network, storage, or other underlying subsystems are from other containers or from the host machine.*

*A container is defined by its image as well as any configuration options you provide to it when you create or start it. When a container is removed, any changes to its state that are not stored in persistent storage disappear."*

To create a container from an image you need to use the [`docker run`](https://docs.docker.com/engine/reference/commandline/run/#mount-volume--v---read-only) command once: 
Here you also specify which ports are used for communication. Different installations use different ports for the virtual machine:

Docker CE installation:
`docker run -d -p 22:22  --name <container name> <image name>`

Docker Toolbox installation
`docker run -d -p 23:22  --name <container name> <image name>`

After running this command the container is up and running and you can start working with the container. At the end of a session you can stop the container and when you start a new session you can use the `docker start` command to start it again.

Useful commands:
To list all containers:

`docker container ls`         (lists running containers)
`docker container ls --all`   (lists all (running and not running containers)


To stop a container:  
`docker stop <container name>` 

To start a container:  
`docker start <container name>`	

To remove a container:  
`docker rm <container name>`		(remove container:  ! warning, this cannot be undone, all your work in this container will be lost) 

When a container is running you can operate it using an [SSH session](./ssh.md) in MobaXterm. In our case the container runs a [Linux operating system](./Linux_intro.md) so you operate the container from a command line in MobaXterm. From there you can do everything you can also do on a Linux computer: manage files and folders, as well as running software. Here you install a Linux version of MATLAB and run and compile MATLAB code.

## Repository

Docker Images can be shared on repositories such as [Docker Hub](https://hub.docker.com/).
On the Docker Hub website you can make an account and create Private and Public repositories.

Via Windows Command Prompt you can connect to your account to access your private repositories.  
```
docker login
<username>  
<password>
```

With `docker push` you can put an image in your 'private' repository. It is not necessary to do this (as you can also keep working with locally saved images), but it can be a handy to have a back up of a good working image. If you want to share the image with others, you can change the repository to 'public'.

Before pushing the image, first tag the image (to check the image name and tag use the `docker images` command)

`docker tag <image name>:<tag> <hub username>/<repository name>:<tag2>`

At `tag2` you may assign a new name tag.

`docker push <hub username>/<repository name>:<tag2>`

To run this command you should create an account first and create a repository on Docker hub. 

To load images you can use the following commands:

To search for images use the [search](https://docs.docker.com/engine/reference/commandline/search/) command:

`docker search <search term>`

the search command will list all images where either image name, repository name or description have a match with the search term.

Next you can pull an image with the [pull](https://docs.docker.com/engine/reference/commandline/pull/) command:

`docker pull <image name>`

The next step will be to create a container from this image with the `docker run` as explained above.

More documentation about repositories can be found [here](https://docs.docker.com/docker-hub/repos/).





