These instructions are provided by Okyeron 🙌  and edited by Nordseele for the NornsHat

# Preparing the Raspberry PI SD card

## Download raspbian stretch lite
https://www.raspberrypi.org/downloads/raspbian/
(tested with 2018-11-13 release)

## Flash raspbian lite to the sdcard
Use balenaEtcher - https://www.balena.io/etcher/ for this. (approx. 5min)

## Sssh configuration (or use the UART header)

 1. **Create a file in Atom** and save it as **wpa-supplicant.conf**

    The file looks like this:


	>     country=fr (your country)
	>     update_config=1
	>     ctrl_interface=/var/run/wpa_supplicant
	>     network={
	>     scan_ssid=1
	>     ssid="Name of your router"
	>     psk="Your key"
	>     }



 2. Then in a terminal :

        cd /volumes && ls
        cd boot && touch ssh

 3. Copy the **wpa-supplicant.conf** file you've created to the root of
   the SD card
 4. Unmount the volume "Boot",load the SD card in the Raspberry Pi and
   power it on.
 5. Find the IP of your Raspberry Pi using a software like Lanscan and
   generate a key (replace XX with the IP of the RPI)

        ssh-keygen -R 192.168.1.XX
 6. Connect via SSH

    `ssh pi@192.168.1.XX` (password: raspberry)


### 4 - RPI adjustments



 1. `sudo raspi-config`

	>    Password : sleep
	>    Network : Hostname (norns)
	>    Interfacing : SSH (on)
	>    Interfacing : Spi (on)
	>    Interfacing : I2s (on)
	>    Advanced : Expand File System
	>    Localization : (en-US-UTF8, US-UTF8)  
	>    Locallization : wifi country > your country
	>    Localization : timezone > your timezone

 2. Reboot. (`sudo reboot`)

 3. Login again

       `ssh pi@192.168.1.XX` (password: sleep)

 4. Change the default user name

        sudo passwd root  (password: sleep)
        sudo nano /etc/ssh/sshd_config

 5. Find this line: `#PermitRootLogin prohibit-password` Edit it so it
    reads : `PermitRootLogin yes`

 6. Close and save the file.

 7. Reboot

 8. Login as root

        ssh root@192.168.1.XX (password: sleep)


 9. Then `usermod -l we -d /home/we -m pi`  

      and `groupmod --new-name we pi`

 10. Exit, and this time login as `we`  

         ssh we@192.168.1.XX (password: sleep)

         sudo passwd -l root

 11. Disable need for passwd with sudo   (sudoers filename will vary -
     tab to autocomplete or `ls /etc/sudoers.d/` to check the filename)


         sudo nano /etc/sudoers.d/010...  

     Change '**pi**' to '**we**'

 12. Save and exit (ctrl + x -> y)

# Linux & Kernel

## Run updates install git, build dependencies, etc
Enter the following commands one by one in the terminal.

    cd ~
	sudo apt-get update
    sudo apt-get dist-upgrade
    sudo apt-get install vim git bc i2c-tools
    sudo apt-get -y install libncurses5-dev
    git clone https://github.com/okyeron/norns-linux-bits.git
    git clone https://github.com/nordseele/nornsHat_install.git
    git clone --depth 1 --branch rpi-4.14.y-rt https://github.com/raspberrypi/linux     
    cd linux
    git checkout 22bb67b8e2e809d0bb6d435c1d20b409861794d2
    cp ~/norns-linux-bits/drivers-staging-fbtft/* /home/we/linux/drivers/staging/fbtft/
	cp ~/norns-linux-bits/arch-arm-configs/bcm2709_defconfig/home/we/linux/arch/arm/configs/bcm2709_defconfig
    cp ~/norns-linux-bits/.config /home/we/linux/.config

## Building the kernel

 1.  ### Setting the scene.

          cd ~/linux
          export KERNEL=kernel7
          make mrproper
          make bcm2709_defconfig
          make modules_prepare

 2. ### Quick verification for the ssd1322
    At this step we need to ensure that the module for the SSD1322 display
    will actually be loaded.

        make menuconfig
       ##### And dive into the menus...

    > *Device Drivers  ---> Staging Drivers ---> Support for small TFT LCD display modules  ---> **SSD1322 driver***

    There should be a letter **M** next to this line. If it's not there type **M** and answer yes or hit enter. Don't forget to hit **save**, the filename is **.config**

 3. ### Compiling the kernel
    The following part will take quite a long time (approx. 1h30)

        make -j4 zImage modules dtbs
        sudo make modules_install
        sudo cp arch/arm/boot/dts/*.dtb /boot/
        sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
        sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
        sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
        sudo reboot
 5. ### Testing the ssd1322
     Now we're going to test the display. If your soldering is fine and if the kernel has been built correctly, you should see the console displayed on the OLED screen but first we need to do this :

        sudo modprobe fbtft_device custom name=fb_ssd1322 width=128 height=64 speed=16000000 gpios=reset:25,dc:24
        con2fbmap 1 1

# Package installs

##### Enter these commands one by one
```
curl https://keybase.io/artfwo/pgp_keys.asc | sudo apt-key add -
echo "deb https://package.monome.org/ stretch main" | sudo tee /etc/apt/sources.list.d/norns.list
```
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

Finally,  `sudo nano /lib/systemd/system/systemd-udevd.service `   and change
    `slave` to `shared`


# Network Manager

Make a quick change to network interfaces so network-manager does not take over wifi

**NOTE** - *At the end of the network-manager install you will get kicked of off wifi and will be assigned a new IP address. You will want to have a keyboard and monitor attached here to login directly and get your IP address with `ifconfig` - or you can fake it by checking a tool like [LanScan](https://itunes.apple.com/us/app/lanscan/id472226235) to find the device on your network.* **Also** - *the IP address will likely change each time you reboot.* *We will fix this at the very end of the install.*

`sudo nano /etc/network/interfaces`

 Add this:

> `auto wlan0`


Then install network-manager and reboot

    sudo apt install network-manager




# Norns setup

 1. ### Prepare

        git clone https://github.com/monome/norns-image.git  
        cd /home/we/nornsHat_install
        ./hat_install.sh

 5. ### Now run setup.sh
    `./setup.sh`

6. ### Install norns
       cd ~
       git clone https://github.com/monome/norns.git
       cd norns
       ./waf configure
       ./waf

7. ### Run sclang   
   `sclang`  and exit with (ctrl + z)

8. ### Install SC
       cd sc
       ./install.sh

9. ### Framebuffer setup for oled

     Edit *matron.sh* to add *-f/dev/fb1*

   `sudo nano ~/norns/matron.sh`

      >     ./build/ws-wrapper/ws-wrapper ws://*:5555 ./build/matron/matron -f/dev/fb1


# Dust and Maiden

Get dust from [updater](https://monome.nyc3.digitaloceanspaces.com/norns190405.tgz) and transfer the folder over SFTP (using Filezilla for example) to the *we* folder on the Raspberry Pi.


Get maiden from github releases:
https://github.com/monome/maiden/releases

```
cd ~
wget https://github.com/monome/maiden/releases/download/v0.13/maiden-v0.13.tgz
tar -xvf maiden-v0.13.tgz
rm maiden-v0.13.tgz
```


# Compiling Overlays


The .dts files needs to be compiled to .dtbo and then the .dtbo needs to be copied to `/boot/overlays/`  

**(NornsHat REV2 users only)**

    cd~
    git clone https://github.com/nordseele/nornsHat_install_files.git
    cd nornsHat_install_files

1. ### Norns-buttons-encoders-overlay
   `sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/norns-buttons-encoders.dtbo norns-buttons-encoders-overlay.dts`  

2. ### Ssd1322
   `sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/ssd1322-spi.dtbo ssd1322-spi-overlay.dts`   


3. ### Edit config.txt
   Add the reference to the overlays to  */boot/config.txt*
`sudo nano /boot/config.txt`  

       # Buttons and encoders
	   dtoverlay=norns-buttons-encoders
	   dtoverlay=ssd1322-spi


# Network / Wifi

### DO THIS AFTER YOU'RE SCREEN IS UP AND RUNNING PROPERLY

Reset `/etc/network/interfaces`  to norns default

```
sudo cp ~/norns-linux-bits/interfaces /etc/network/interfaces
```

Rename /etc/wpa_supplicant/wpa_supplicant.conf to something else and reboot.   
this should get network manager to take over   

```
mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_bak.conf
```

Reboot

At this point you will want to login to your wifi from the device screen so network manager remembers your wifi info.
