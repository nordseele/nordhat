cp -f setup.sh /home/we/norns-image
cp -f norns_matron.service /home/we/norns-image/config
cp -f init-norns.sh /home/we/norns-image/scripts
cp -f norns-init.service /etc/systemd/system/
cp -f norns.target /home/we/norns-image/config

cp -f raspi-blacklist.conf /etc/modprobe.d
cp -f asound.conf /etc
cp -f alsa.conf /usr/share/alsa
