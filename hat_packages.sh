curl https://keybase.io/artfwo/pgp_keys.asc | sudo apt-key add -
echo "deb https://package.monome.org/ stretch main" | sudo tee /etc/apt/sources.list.d/norns.list

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

sudo cp -f systemd-udevd.service /lib/systemd/system/
sudo cp -f interfaces /etc/network
sudo apt install network-manager
sudo reboot 
