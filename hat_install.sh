sudo cp -f setup.sh /home/we/norns-image
sudo cp -f norns-matron.service /home/we/norns-image/config
sudo cp -f init-norns.sh /home/we/norns-image/scripts
sudo cp -f norns-init.service /etc/systemd/system/
sudo cp -f norns.target /home/we/norns-image/config

sudo cp -f raspi-blacklist.conf /etc/modprobe.d
sudo cp -f asound.conf /etc
sudo cp -f alsa.conf /usr/share/alsa
