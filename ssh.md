# SSH

SSH stands for secure shell and is a protocol that makes it possible to remotely login to other computers (such as HPC clusters or virtual machines).
To setup this connection, you need a terminal application. We recommend [MobaXterm](https://mobaxterm.mobatek.net/download.html) to do this.

To start a session in MobaXterm: click the Session tab, and fill in the Basic SSH settings: the host that you want to connect to, the username and the port. Potentially some additional settings need to be filled in to smooth the login process at HPC systems: e.g. to jump from a gateway node to a submit node directly upon login, or to attach a key. For these type of settings, follow the login instructions from the HPC system ( [UBC](https://wiki.bioinformatics.umcutrecht.nl/bin/view/HPC/HowToS#How_to_log_in_from_outside_the_U)  [LISA](https://userinfo.surfsara.nl/systems/lisa/getting-started) ).








Connection via keys exchange
Each device needs to exchange keys to make 
Docker container as well as windows machine




# SCP
!!!!!!!There are two ways to transfer files between Lisa and your PC: via the scp command in the terminal, or using an FTP file browser.

If you open a terminal on your local machine (i.e. without logging in to Lisa), you can use scp to copy files. The syntax is

scp [source] [destination]

For example, to copy my_file from the current directory on your local machine to the directory destinationdir on Lisa.

scp my_file <username>@lisa.surfsara.nl:destinationdir

Alternatively, you can install and use an SFTP browser such as!!!!!


sftp
Manual copy
Command line copy


Software








