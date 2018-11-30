
## Export Display Issues

If there is no new window opening when running the `xclock` command or when running the MATLAB installer or MATLAB, there may be something wrong with configuration of the X server or the `export DISPLAY` variable. Check the following things for a potential solution. If these are all not working, contact ...

# Check if X server is running.

The X server in MobaXterm should be running in order to allow display forwarding.
Open the MobaXterm window and check in the top right corner whether the X server icon is green. If it is red, click it to start the X server (it will become green).

# Check display address of X server

Put your cursur on the X server icon in the top right corner of the MobaXterm window and check the address of the display (current DISPLAY=....).

This should be the same the address given with the `export DISPLAY=` command in your docker container (part 1, step 8). It could e.g. that instead of <IPv4 address>:0.0, it shows <IPv4 address>:1.0

If not exactly the same, run the `export DISPLAY=`  command again in your docker container with the exact numbers found in MobaXterm.

# Check X server settings.

In MobaXterm, click the settings icon (or alternatively, click the settings tab, and click 'Configuration') 

Click the X11 tab.

Set the 'X11 remote access' field to 'full'.

Click OK.

# Firewall 
 
If the above settings are all OK, it could be that display forwarding is blocked by your firewall. Check both the firewall in your anti virus software and the windows or mac firewall.

In your commercial anti virus software, it could be that only changing your firewall profile from 'public network' to 'private network' ('openbaar netwerk' to 'prive netwerk') will do the trick. 

Otherwise check the 'log' of your firewall to see if there have been any applications blocked around the times that you ran the `xclock` command. You may have to allow specific permissions for this application, but be careful and make sure that it is indeed the application that tries to forward display.

Check windows (or mac) firewall.

Open Settings.
Go to Network & Internet - Status.
Scroll down to the link "Windows Firewall" and click it.
There, click the link "Allow an app or feature through Windows Firewall" on the left side.
Click the button "Change settings"
Scroll down until you see apps like 'X-win' and 'xwin-mobax' and allow communication, or add the apps if they are not in the list.

## Matlab command not found.

# When matlab does not start (bash: matlab: command not found )
Check if matlab is properly installed in the right directory in your Docker container.

```
cd /opt/matlab/
ls
```

The ls command should show a list of folders (e.g. bin, appdata, java, etc) and a few text files.
If not, it is probably easiest to exit this docker container, stop and remove the container, and start from part 1 step 5. Make sure to select the right destination folder when installing matlab.





