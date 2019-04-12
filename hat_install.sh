sudo cp -f setup.sh /home/we/norns-image
sudo cp -f norns-matron.service /home/we/norns-image/config
sudo cp -f init-norns.sh /home/we/norns-image/scripts
sudo cp -f norns-init.service /etc/systemd/system/
sudo cp -f norns.target /home/we/norns-image/config

sudo cp -f raspi-blacklist.conf /etc/modprobe.d
sudo cp -f asound.conf /etc
sudo cp -f alsa.conf /usr/share/alsa

sudo cp -f matron.sh /home/we/norns

# compile the overlays (buttons and encoders + ssd1322)
sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/norns-buttons-encoders.dtbo /home/we/nornsHat_install/overlays/norns-buttons-encoders-overlay.dts
sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/ssd1322-spi.dtbo /home/we/nornsHat_install/overlays/ssd1322-spi-overlay.dts
