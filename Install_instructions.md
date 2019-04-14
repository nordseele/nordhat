# Preparing the Raspberry PI

### Download raspbian stretch lite
https://www.raspberrypi.org/downloads/raspbian/  
(tested with 2018-11-13 release)

### Flash raspbian lite to the sdcard
Use balenaEtcher - https://www.balena.io/etcher/ for this.

### SSH configuration

 Create a **wpa-supplicant.conf** file for your network and copy the file to the root of the ***boot*** volume

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
Enter the following commands in a terminal, edit if needed (country etc).

`sudo raspi-config nonint do_hostname norns`  
`sudo raspi-config nonint do_spi 1`  
`sudo raspi-config nonint do_wifi_country FR`  
`sudo raspi-config nonint do_expand_rootfs`  
`sudo su`  
`passwd pi` (sleep)  
`sudo reboot`  
`ssh keygen -R norns.local`  
`sudo passwd root` (sleep)  
`sudo nano /etc/ssh/sshd_config` ("PermitRootLogin" needs to be set to "yes" and uncomment the line)  
`sudo reboot`  
`ssh root@norns.local`  
`usermod -l we -d /home/we -m pi`   
`groupmod --new-name we pi`  
`exit`  
`ssh we@norns.local`  
`sudo passwd -l root`  
`sudo nano /etc/sudoers.d/010_pi-nopasswd` (change pi to we)  
`sudo reboot`

# Linux & Kernel

## Run updates install git, build dependencies, etc
Enter the following commands one line at a time in the terminal.

    cd ~
	sudo apt-get update
    sudo apt-get dist-upgrade -y
    sudo apt-get install vim git bc i2c-tools -y
    git clone https://github.com/nordseele/nornsHat_install.git
    cd nornsHat_install && ./hat_prepare.sh


### Testing the ssd1322
Now we're going to test the display. If your soldering is fine and if the kernel has been built correctly, you should see the console displayed on the OLED screen but first we need to do this :

    sudo modprobe fbtft_device custom name=fb_ssd1322 width=128 height=64 speed=16000000 gpios=reset:25,dc:24
    con2fbmap 1 1

# Norns

    cd /home/we/nornsHat_install &&./hat_install.sh
Answer ***yes (y)*** to "enable realtime priority"
