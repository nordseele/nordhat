cd /home/we
git clone https://github.com/monome/norns-image.git

sudo cp -f /home/we/nordhat/install/norns/files/setup.sh /home/we/norns-image
sudo cp -f /home/we/nordhat/install/norns/files/norns-matron.service /home/we/norns-image/config
sudo cp -f /home/we/nordhat/install/norns/files/init-norns.sh /home/we/norns-image/scripts
sudo cp -f /home/we/nordhat/install/norns/files/norns-init.service /etc/systemd/system/
sudo cp -f /home/we/nordhat/install/norns/files/norns.target /home/we/norns-image/config
sudo cp -f /home/we/nordhat/install/norns/files/aliases.conf /lib/modprobe.d
sudo cp -f /home/we/nordhat/install/norns/files/raspi-blacklist.conf /etc/modprobe.d
sudo cp -f /home/we/nordhat/install/norns/files/asound.conf /etc
sudo cp -f /home/we/nordhat/install/norns/files/alsa.conf /usr/share/alsa

# compile the overlays (buttons and encoders + ssd1322)
sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/nord-buttons-encoders.dtbo /home/we/nordhat/overlays/nord-buttons-encoders-overlay.dts
sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/ssd1322-spi.dtbo /home/we/nordhat/overlays/ssd1322-spi-overlay.dts

cd /home/we/norns-image
./setup.sh

cd /home/we
git clone https://github.com/monome/norns.git
cd /home/we/norns

# we need to run sclang
echo | sclang

./waf configure
./waf

cd /home/we/norns/sc && ./install.sh

sudo cp -f /home/we/nordhat/install/norns/files/matron.sh /home/we/norns
sudo cp -f /home/we/nordhat/install/norns/files/config.txt /boot

cd ~
mkdir dust
cd dust
mkdir code
mkdir audio
mkdir data
cd code
git clone https://github.com/monome/we.git
git clone https://github.com/tehn/awake.git

cd ~
wget https://github.com/monome/maiden/releases/download/v0.13/maiden-v0.13.tgz
tar -xvf maiden-v0.13.tgz
rm maiden-v0.13.tgz


#sudo cp ~/norns-linux-bits/interfaces /etc/network/interfaces
#sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_bak.conf

sudo reboot
