# What is a cluster computer

_"You can imagine a cluster computer as a collection of regular computers (known as nodes), tied together with network cables that are similar to the network cables in your home or office. Each node has its own CPU, memory and disk space, in addition to which they generally have access to a shared file system. On a cluster computer, you can run hundreds of computational tasks simultaneously._

_Interacting with a cluster computer is different from a normal computer. Normal computers are mostly used interactively, i.e. you type a command or click with your mouse, and your computer instantly responds by e.g. running a program. Cluster computers are mostly used non-interactively._ 

_A cluster computer such as Lisa has (at least) two types of nodes: login nodes and batch nodes. You connect through a login node. This is an interactive node: similar to your own pc, it immediately responds to the commands you type. There are only a few login nodes on a cluster computer, and you only use them for light tasks: writing and compiling software, preparing your input data, writing job scripts. Since the login nodes are only meant for light tasks, many users can be on the same login node at the same time._

_Your 'big' calculations will be done on the batch nodes. These perform what is known as batch jobs. A batch job is essentially a recipe of commands (put together in a job script) that you want the computer to execute. Calculations on the batch nodes are not performed right away. Instead, you submit your job script to the job queue. As soon as sufficient resources (i.e. batch nodes) are available for your job, the system will take your job from the queue, and send it to the batch nodes for execution._

_In the sections below, we explain how you can login to the login nodes of Lisa, execute some basic Linux commands there (interactively), write a job script, submit it to the job queue, and finally inspect your output once your job is finished._ ( [Surfsara](https://userinfo.surfsara.nl/systems/lisa/getting-started) )

Nodes vs Cores
Navigation Linux

SSH and SCP connection

Text editing

Job submission syntax and options
