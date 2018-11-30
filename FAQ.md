
master
=======
## Export Display issues

# Check if X server is running.

The X server in MobaXterm should be running in order to allow display forwarding.
Open the MobaXterm window and check in the top right corner whether the X server icon is green.

# Check display address of X server

Put your cursur on the X server icon in the top right corner of the MobaXterm window and check the address of the (current DISPLAY=....)

This should be the same the address given with the `export DISPLAY=` command. It could e.g. that instead of <IPv4 address>:0.0, it shows <IPv4 address>:1.0

If not exactly the same, run the `export DISPLAY=`  command again with the exact numbers found in MobaXterm.

# Check X server settings.

Click the settings icon (or click the settings tab, and click 'Configuration') 

Click the X11 tab.

Set the 'X11 remote access' field to 'full'.

Click OK.

# Firewall 
 
Check your anti virus software
Check windows firewall

nonroot-user
