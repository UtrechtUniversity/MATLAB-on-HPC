#!/bin/bash
mkdir /opt/matlab
echo making directory /opt/matlab
echo IMPORTANT 
echo choose to install matlab in /opt/matlab
sudo ./install
ln -s /opt/matlab/bin/matlab /usr/local/bin/matlab
ln -s /opt/matlab/bin/mcc /usr/local/bin/mcc
echo install
echo finished installer script as: 
whoami