---
output:
  pdf_document: default
  html_document: default
---
# MATLAB-on-HPC contents

## Introduction
MATLAB is versatile software for numerical computing and can be used for a wide range of tasks. When the required MATLAB computations are expected to take a long time (in the order of weeks) to complete, e.g. due to large data files or a very high number of calculations, it can be a good idea to use High Performance Computing (HPC).   
Not only is it possible to obtain results faster; by performing most of your calculations on an HPC system, you keep your local working station free for other tasks.  
However, there are some extra actions involved compared to running MATLAB on a local working station. In short: For running MATLAB on HPC one typically translates ('compile') code into 'machine language'. This is done with a single command. Then the compiled code has to be transferred to the HPC system, together with input data. After running the compiled code at HPC, the results are transfered back to the local system, where the results can be viewed. 

## Costs and benefits
To decide whether or not to start with HPC as a researcher can be difficult. The benefits should outweigh the costs but on forehand this is not easy to estimate.

**Costs**  
You have to invest time in order to learn how to manage your scripts, your data and operate the HPC system. How much time this is difficult to say and depends on previous experience with HPC, Linux, SSH connections, etc.
This manual is suitable for different entry levels and is composed of different components.  
An experienced user can run through the step-by-step instruction (probably within a couple of hours). New users can make use of the different introductory manuals that are linked to during the step-by-step instructions (to go through all manuals will probably cost a couple of days). Beginning users may lose some more time solving issues during daily usage of the HPC system.  
Note that you also need an (paid) account for the clusters. It may take some time before everything is approved and you can login. 

**Benefits**  
If your computation tasks consist of many calculations that are independent of each other (the calculations don't need information from other calculations), there is high potential for speeding up these calculations using HPC. If these calculations are equal in size (take more or less the same time to complete). You can achieve almost linear speed ups: using e.g. 16 cores at the same time will result in obtaining your results almost in 1/16th of the time 1 core would take.   
Many MATLAB functions are executed in parallel by default (e.g. Matrix multiplication, fft, eig, cos). If such functions take a significant amount of time during the execution of your script, it is likely that high speed ups can be obtained by using HPC.  
Scan [this page](./matlab.md) for backgrounds of parallelization of MATLAB scripts and to see some test results of speed ups of different typs of parallelization.

## Step-by-step workflow
Researchers at Utrecht University typically perform their calculations at the [UBC cluster](https://wiki.bioinformatics.umcutrecht.nl/bin/view/HPC/WebHome) or at [SURFsara](https://userinfo.surfsara.nl/). This guide presents a step-by-step workflow to make it possible to run your MATLAB script on both clusters.  
In some of the steps links are provided to introductory text to learn more about the backgrounds when required.

Below you find links to the different parts of the workflow we recommend.
Part 1 describes all preparatory steps regarding installation of software and only need to be performed once.
Part 2 describes the steps that are used for running code on HPC on a regular basis. 
Part 3 provides examples of ways to parallelize MATLAB code and make full use of HPC.


## Contents

Part 1: [Installing docker software and MATLAB](./Part-1-preparation.md)  *(estimated time to complete)*  
    *This part describes all preparatory steps regarding installation of software. This part only needs to be performed once.*
    
Part 2: [Compiling MATLAB scripts and running on HPC](./Part-2-running-matlab.md)  *(estimated time to complete)*  
    *This part describes the steps that are used for running code on HPC.*

Part 3: [Parallel computing with MATLAB](./matlab.md)  *(estimated time to complete )*  
    *This part provides examples of ways to parallelize MATLAB code and benchmark tests how these parallelization perform on HPC.*


## Links

[Introduction to Linux](./Linux_intro.md)  
[Introduction to Docker](./Docker_intro.md)  
[Introduction to HPC](./HPC_intro.md)  
[Intro SSH & SCP](./ssh.md)  
[MATLAB Test script 1](./Test_1.m)
[MATLAB Test script 2](./test_matmul.m)  
[MATLAB Test script 3](./test_solve.m)  
[MATLAB Test script 4](./test_parallel.m)  


