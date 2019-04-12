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

 Save and close the file. Reboot. Login as root `ssh root@192.168.1.XX`


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
    git clone https://github.com/okyeron/norns-linux-bits.git
    git clone https://github.com/nordseele/nornsHat_install.git
  ```
  ***experimental*** >

  cd nornsHat_install
  ./hat_prepare.sh
  ```
    sudo apt-get -y install libncurses5-dev

    git clone --depth 1 --branch rpi-4.14.y-rt https://github.com/raspberrypi/linux     
    cd linux
    git checkout 22bb67b8e2e809d0bb6d435c1d20b409861794d2
    cp ~/norns-linux-bits/drivers-staging-fbtft/* /home/we/linux/drivers/staging/fbtft/
	cp ~/norns-linux-bits/arch-arm-configs/bcm2709_defconfig/home/we/linux/arch/arm/configs/bcm2709_defconfig
    cp ~/norns-linux-bits/.config /home/we/linux/.config

## Building the kernel

### Setting the scene

    cd ~/linux
    export KERNEL=kernel7
    make mrproper
    make bcm2709_defconfig
    make modules_prepare

### Quick verification for the ssd1322
  At this step we need to ensure that the module for the SSD1322 display
  will actually be loaded.

    make menuconfig
  ##### And dive into the menus...

    Device Drivers  ---> Staging Drivers ---> Support for small TFT LCD display modules  ---> **SSD1322 driver**

  There should be a letter **M** next to this line. If it's not there type **M** and answer yes or hit enter. Don't forget to hit **save**, the filename is **.config**

### Compiling the kernel

    make -j4 zImage modules dtbs
    sudo make modules_install
    sudo cp arch/arm/boot/dts/*.dtb /boot/
    sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
    sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
    sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
    sudo reboot


### Testing the ssd1322
Now we're going to test the display. If your soldering is fine and if the kernel has been built correctly, you should see the console displayed on the OLED screen but first we need to do this :

    sudo modprobe fbtft_device custom name=fb_ssd1322 width=128 height=64 speed=16000000 gpios=reset:25,dc:24
    con2fbmap 1 1

# Package installs


```
***experimental***
cd nornsHat_install
./hat_packages.sh
``
Enter these commands (two different commands)

    curl https://keybase.io/artfwo/pgp_keys.asc | sudo apt-key add -
    echo "deb https://package.monome.org/ stretch main" | sudo tee /etc/apt/sources.list.d/norns.list
```
sudo apt update
sudo apt install --no-install-recommends jackd2
sudo apt-get install libboost1.62-dev
sudo apt-get install libjack-jackd2-dev
sudo apt install libmonome-dev libnanomsg-dev supercollider-language supercollider-server supercollider-supernova supercollider-dev liblua5.3-dev libudev-dev libevdev-dev liblo-dev libcairo2-dev liblua5.3-dev libavahi-compat-libdnssd-dev libasound2-dev
sudo apt install dnsmasq
sudo apt install sc3-plugins ladspalist
sudo apt install usbmount
sudo apt-get install alsa-utils
sudo apt-get install libi2c-dev
```

Finally,  `sudo nano /lib/systemd/system/systemd-udevd.service ` and change
    `slave` to `shared`


### Network Manager

Make a quick change to network interfaces so network-manager does not take over wifi

**NOTE** - *At the end of the network-manager install you will get kicked of off wifi and will be assigned a new IP address. You will want to have a keyboard and monitor attached here to login directly and get your IP address with `ifconfig` - or you can fake it by checking a tool like [LanScan](https://itunes.apple.com/us/app/lanscan/id472226235) to find the device on your network.* **Also** - *the IP address will likely change each time you reboot.* *We will fix this at the very end of the install.*

`sudo nano /etc/network/interfaces`

 Add this:

`auto wlan0`


Then install network-manager and reboot

    sudo apt install network-manager


# Norns setup

### Norns image

    git clone https://github.com/monome/norns-image.git  
    cd /home/we/nornsHat_install
    ./hat_install.sh
    cd ~/norns-image
    ./setup.sh

### Norns
    cd ~
    git clone https://github.com/monome/norns.git
    cd norns
    ./waf configure
    ./waf

### Run sclang   
   `sclang`  and exit (with ctrl + z)

### Install SC
    cd sc
    ./install.sh


# Dust and Maiden

Get dust from [updater](https://monome.nyc3.digitaloceanspaces.com/norns190405.tgz) and transfer the folder over SFTP (using Filezilla for example) to the ***we*** folder on the Raspberry Pi.


Get maiden from github releases:
https://github.com/monome/maiden/releases

```
cd ~
wget https://github.com/monome/maiden/releases/download/v0.13/maiden-v0.13.tgz
tar -xvf maiden-v0.13.tgz
rm maiden-v0.13.tgz
```

# Network / Wifi

```
sudo cp ~/norns-linux-bits/interfaces /etc/network/interfaces
```

```
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_bak.conf
```

Reboot and login to your wifi from the device screen so network manager remembers your wifi info.
