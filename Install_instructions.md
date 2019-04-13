# Preparing the Raspberry PI

### Download raspbian stretch lite
https://www.raspberrypi.org/downloads/raspbian/  
(tested with 2018-11-13 release)

### Flash raspbian lite to the sdcard
Use balenaEtcher - https://www.balena.io/etcher/ for this.

### SSH configuration

 Create a file in Atom and save it as **wpa-supplicant.conf**

    country=fr (your country)
    update_config=1
    ctrl_interface=/var/run/wpa_supplicant
    network={
      scan_ssid=1
      ssid="Name of your router"
      psk="Your key"
    }

Open a terminal and type paste the following commands, one line at a time:

    cd /volumes && ls
    cd boot && touch ssh

Move the **wpa-supplicant.conf** file you've created to the root of the SD card and then unmount the sd card.

### Mount the SD card and boot the Raspberry Pi

Find the IP of your Raspberry Pi using a software like Lanscan and
   generate a key (replace XX with the IP of the RPI).  
Open a terminal and enter the following command (XX is the last two digits of the PI's IP).  
`ssh-keygen -R 192.168.1.XX`

Connect via SSH. `ssh pi@192.168.1.XX` The password is ***raspberry***

### RPI adjustments

`sudo raspi-config`
An interactive command line will open, you need to make the following adjustements.  
When you're done: ***save and reboot***.

	Password : sleep
	Network : Hostname : norns
	Interfacing : Spi (on)  
	Advanced : Expand File System  
	Localization : (en-US-UTF8, US-UTF8)    
	Localization : wifi country > your country  
	Localization : timezone > your timezone

Login again `ssh pi@192.168.1.XX` The password is ***sleep***

Change the default user name

  `sudo passwd root` The password is ***sleep***

  `sudo nano /etc/ssh/sshd_config`

Find this line: `#PermitRootLogin prohibit-password` and edit it so it
    reads : `PermitRootLogin yes`

 Save and close the file. ***Reboot***.  
 Login as root `ssh root@192.168.1.XX`


Then `usermod -l we -d /home/we -m pi`  and `groupmod --new-name we pi`

Exit, and this time login as ***we***  

`ssh we@192.168.1.XX` The password is ***sleep***

`sudo passwd -l root`

`sudo nano /etc/sudoers.d/010_pi-nopasswd`  and change '**pi**' to '**we**'


# Linux & Kernel

## Run updates install git, build dependencies, etc
Enter the following commands one line at a time in the terminal.

    cd ~
	sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get install vim git bc i2c-tools
    git clone https://github.com/nordseele/nornsHat_install.git
    cd nornsHat_install
    ./hat_prepare.sh


### Testing the ssd1322
Now we're going to test the display. If your soldering is fine and if the kernel has been built correctly, you should see the console displayed on the OLED screen but first we need to do this :

    sudo modprobe fbtft_device custom name=fb_ssd1322 width=128 height=64 speed=16000000 gpios=reset:25,dc:24
    con2fbmap 1 1

# Package installs


    cd nornsHat_install
    ./hat_packages.sh

Answer ***yes (y)*** to everything. The device will reboot at the end of the process and will probably have a new ip address so you will need to open a new terminal window and reconnect `ssh we@norns.local`

# Norns setup

### Norns

    cd /home/we/nornsHat_install
    ./hat_install.sh

### Run sclang   
   `sclang`  and exit (with ctrl + z)

### Install SC
    cd /home/we/norns/sc
    ./install.sh
