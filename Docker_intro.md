# Why Docker?

MATLAB needs to be compiled under linux, to be able to execute on HPC.

Although it is possible to do this on LISA (where matlab is installed) and UBC (where matlab can be installed), there are some limitations
A Docker container is a much more flexible way to test, debug, work and compile locally. 

On UBC 




# Versions
Windows Pro
Windows Home
MAC


Virtual machines
Oracle VM
???





# How to work with docker
For a full introduction, the user is referred to the website of Docker. The [Overview](https://docs.docker.com/engine/docker-overview/) page gives an overview of the architecture of Docker. The [Getting started](https://docs.docker.com/get-started/) page gives instructions of how to create docker images and containers. Only Part 1 and 2 of the Getting started pages are really relevant for our aims.

Here we provide specific and very basic backgrounds that are needed for installing a docker container with MATLAB and a list of useful commands.

## Architecture

Images
Dockerfile

Containers
I.e. Run instance of Image with software

SSH to container

Shipping containers
Repositories


## operating docker
Windows command line
more flexible than the standard docker software (e.g. Docker quickstart terminal)

First create a Virtual Machine Docker machine

Create image
Pull image from repository

Build or pull container

SSH to container and ready to use

Useful commands:

Remove images (! Warning, only do when to start from begin)
docker system prune		(remove unused images)
docker system prune -a 	(remove archived images)
docker rm matlab2018a 		(remove container:  ! warning all changes to container will also be removed) 

docker-machine start default
docker-machine stop default
docker stop matlab2018a 		(stop container)
docker start matlab2018a	(start container )
docker image ls -a                             # List all images on this machine
docker container ls --all
docker container ls                                # List all running container