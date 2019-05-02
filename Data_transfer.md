# Data transfer between Docker Container and HPC

There are two ways to transfer files between your Docker container and the HPC cluster using the SCP protocol: via command line (fast, reproducible  approach) or using software with a graphical user interface (intuitive for beginning users).

### Transfer using command line

**Online cloud storage**  
It is possible to synchronize data between the Docker container and an online storage platform (such as Yoda or Surfdrive).  This approach fits in the recommended workflow for High Performance Computing (see [this page](https://github.com/UtrechtUniversity/HPC-data-synchronization/blob/master/docs/workflow.md)).

Transfer between Surfdrive (and Onedrive, Dropbox, Google drive, etc.) and the Docker container can be done using Rclone. Instructions for installing and using Rclone are available for [Surfdrive](https://github.com/UtrechtUniversity/HPC-data-synchronization/blob/master/docs/surfdrive.md). Although these instructions are initially written for using Rclone on HPC platforms, the installation procedure in the Docker container is equal.

Transfer between Yoda and the Docker container can be done using icommands. Instructions for configuring and using icommands can be found [here](https://github.com/UtrechtUniversity/HPC-data-synchronization/blob/master/docs/Yoda.md). Although these instructions are initially written for using icommands on HPC platforms, the configuration procedure for the Docker container is equal.


**Secure Copy**

To transfer between docker container and HPC cluster use the scp command. 

Scp works very similar to [SSH](./ssh.md). 

In an active docker container session, you can use scp to copy files directly to an HPC cluster. The syntax is:

```
scp <file> <destination>
```
For example, to copy a file named e.g. `myfile.txt` from the current directory on your local machine to the directory destinationdir on the cluster:

```
scp myfile.txt <remote adress>:destinationdir
```

For Lisa:

```
scp myfile.txt <username>@lisa.surfsara.nl:/home/<username>/<destination folder>
```

For UBC, you have to configure the connection first as described in the [SSH manual](./ssh.md) (see: Establish SSH connection between Docker container and UBC cluster).

When you have exchanged keys and created a config file using VIM, you can use the `scp` command as below:

```
scp myfile.txt gw2hpcs03:/home/<usergroup>/<username>/<destination folder>
```

### Manual copy

To manually copy files you need an interactive 'client' software (such as MobaXterm or WinSCP). Copying manually is intuitive, but you always copy files between your local PC and a remote (or virtually remote) location such as a Docker container or HPC cluster. To get files from Docker container to HPC cluster, you first transfer files to a folder on your local PC, and in the next step you transfer files to your 

## Manual transfer between PC and Docker container

You need to establish an SSH session to your Docker container with MobaXterm (or WinSCP). Follow the [SSH manual](./ssh.md) for this. When in an active SSH session, there may already be a side-bar visible in the left of your window. If this subwindow not visible, click View > Show/Hide Side-bar. 

On the left of the Sidebar, click Sftp

At the bottom of the Sidebar, check the ‘Follow terminal folder’ box.

To transfer files to your local PC, select files and click 'download selected files' at the top of the subwindow.

To transfer files from your local machine, click the 'upload to current folder' button.

## Manual transfer between PC and HPC

Similarly, first start an [SSH session](./ssh.md) to HPC using MobaXterm (or WinSCP).

When in an active SSH session, there may already be a side-bar visible in the left of your window. If this subwindow not visible, click View > Show/Hide Side-bar. 

On the left of the Sidebar, click Sftp

At the bottom of the Sidebar, check the ‘Follow terminal folder’ box.

To transfer files to your local PC, select files and click 'download selected files' at the top of the subwindow.

To transfer files from your local machine, click the 'upload to current folder' button.
