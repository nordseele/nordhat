sudo apt-get -y install libncurses5-dev
cd /home/we
git clone --depth 1 --branch rpi-4.14.y-rt https://github.com/raspberrypi/linux
cd linux
git checkout 22bb67b8e2e809d0bb6d435c1d20b409861794d2
cp ~/norns-linux-bits/drivers-staging-fbtft/* /home/we/linux/drivers/staging/fbtft/
cp ~/norns-linux-bits/arch-arm-configs/bcm2709_defconfig/home/we/linux/arch/arm/configs/bcm2709_defconfig
cp ~/norns-linux-bits/.config /home/we/linux/.config
