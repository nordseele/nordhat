---


---

<p>These instructions are provided by Okyeron 🙌  and edited by Nordseele for the NornsHat</p>
<h1 id="preparing-the-raspberry-pi-sd-card">Preparing the Raspberry PI SD card</h1>
<h2 id="download-raspbian-stretch-lite">Download raspbian stretch lite</h2>
<p><a href="https://www.raspberrypi.org/downloads/raspbian/">https://www.raspberrypi.org/downloads/raspbian/</a><br>
(tested with 2018-11-13 release)</p>
<h2 id="flash-raspbian-lite-to-the-sdcard">Flash raspbian lite to the sdcard</h2>
<p>Use balenaEtcher - <a href="https://www.balena.io/etcher/">https://www.balena.io/etcher/</a> for this. (approx. 5min)</p>
<h2 id="sssh-configuration-or-use-the-uart-header">Sssh configuration (or use the UART header)</h2>
<ol>
<li>
<p><strong>Create a file in Atom</strong> and save it as <strong>wpa-supplicant.conf</strong></p>
<p>The file looks like this:</p>
<blockquote>
<pre><code>country=fr (your country)
update_config=1
ctrl_interface=/var/run/wpa_supplicant
network={
scan_ssid=1
ssid="Name of your router"
psk="Your key"
}
</code></pre>
</blockquote>
</li>
<li>
<p>Then in a terminal :</p>
<pre><code>cd /volumes &amp;&amp; ls
cd boot &amp;&amp; touch ssh
</code></pre>
</li>
<li>
<p>Copy the <strong>wpa-supplicant.conf</strong> file you’ve created to the root of<br>
the SD card</p>
</li>
<li>
<p>Unmount the volume “Boot”,load the SD card in the Raspberry Pi and<br>
power it on.</p>
</li>
<li>
<p>Find the IP of your Raspberry Pi using a software like Lanscan and<br>
generate a key (replace XX with the IP of the RPI)</p>
<pre><code>ssh-keygen -R 192.168.1.XX
</code></pre>
</li>
<li>
<p>Connect via SSH</p>
<p><code>ssh pi@192.168.1.XX</code> (password: raspberry)</p>
</li>
</ol>
<h3 id="rpi-adjustments">4 - RPI adjustments</h3>
<ol>
<li>
<p><code>sudo raspi-config</code></p>
<blockquote>
<p>Password : sleep<br>
Network : Hostname (norns)<br>
Interfacing : SSH (on)<br>
Interfacing : Spi (on)<br>
Interfacing : I2s (on)<br>
Advanced : Expand File System<br>
Localization : (en-US-UTF8, US-UTF8)<br>
Locallization : wifi country &gt; your country<br>
Localization : timezone &gt; your timezone</p>
</blockquote>
</li>
<li>
<p>Reboot. (<code>sudo reboot</code>)</p>
</li>
<li>
<p>Login again</p>
<p><code>ssh pi@192.168.1.XX</code> (password: sleep)</p>
</li>
<li>
<p>Change the default user name</p>
<pre><code>sudo passwd root  (password: sleep)
sudo nano /etc/ssh/sshd_config
</code></pre>
</li>
<li>
<p>Find this line: <code>#PermitRootLogin prohibit-password</code> Edit it so it<br>
reads : <code>PermitRootLogin yes</code></p>
</li>
<li>
<p>Close and save the file.</p>
</li>
<li>
<p>Reboot</p>
</li>
<li>
<p>Login as root</p>
<pre><code>ssh root@192.168.1.XX (password: sleep)
</code></pre>
</li>
<li>
<p>Then <code>usermod -l we -d /home/we -m pi</code></p>
<p>and <code>groupmod --new-name we pi</code></p>
</li>
<li>
<p>Exit, and this time login as <code>we</code></p>
<pre><code>ssh we@192.168.1.XX (password: sleep)

sudo passwd -l root
</code></pre>
</li>
<li>
<p>Disable need for passwd with sudo   (sudoers filename will vary -<br>
tab to autocomplete or <code>ls /etc/sudoers.d/</code> to check the filename)</p>
<pre><code>sudo nano /etc/sudoers.d/010...  
</code></pre>
<p>Change ‘<strong>pi</strong>’ to ‘<strong>we</strong>’</p>
</li>
<li>
<p>Save and exit (ctrl + x -&gt; y)</p>
</li>
</ol>
<h1 id="linux--kernel">Linux &amp; Kernel</h1>
<h2 id="run-updates-install-git-build-dependencies-etc">Run updates install git, build dependencies, etc</h2>
<p>Enter the following commands one by one in the terminal.</p>
<pre><code>cd ~ 
sudo apt-get update 
sudo apt-get dist-upgrade
sudo apt-get install vim git bc i2c-tools 
sudo apt-get -y install libncurses5-dev
git clone https://github.com/okyeron/norns-linux-bits.git
git clone --depth 1 --branch rpi-4.14.y-rt https://github.com/raspberrypi/linux     
cd linux
git checkout 22bb67b8e2e809d0bb6d435c1d20b409861794d2
cp ~/norns-linux-bits/drivers-staging-fbtft/* /home/we/linux/drivers/staging/fbtft/
cp ~/norns-linux-bits/arch-arm-configs/bcm2709_defconfig/home/we/linux/arch/arm/configs/bcm2709_defconfig
cp ~/norns-linux-bits/.config /home/we/linux/.config
</code></pre>
<h2 id="building-the-kernel">Building the kernel</h2>
<ol>
<li>
<h3 id="setting-the-scene.">Setting the scene.</h3>
<pre><code> cd ~/linux
 export KERNEL=kernel7
 make mrproper
 make bcm2709_defconfig 
 make modules_prepare
</code></pre>
</li>
<li>
<h3 id="quick-verification-for-the-ssd1322">Quick verification for the ssd1322</h3>
<p>At this step we need to ensure that the module for the SSD1322 display<br>
will actually be loaded.</p>
<pre><code>make menuconfig
</code></pre>
<h5 id="and-dive-into-the-menus...">And dive into the menus…</h5>
<blockquote>
<p><em>Device Drivers  —&gt; Staging Drivers —&gt; Support for small TFT LCD display modules  —&gt; <strong>SSD1322 driver</strong></em></p>
</blockquote>
<p>There should be a letter <strong>M</strong> next to this line. If it’s not there type <strong>M</strong> and answer yes or hit enter. Don’t forget to hit <strong>save</strong>, the filename is <strong>.config</strong></p>
</li>
<li>
<h3 id="compiling-the-kernel">Compiling the kernel</h3>
<p>The following part will take quite a long time (approx. 1h30)</p>
<pre><code>make -j4 zImage modules dtbs
sudo make modules_install
sudo cp arch/arm/boot/dts/*.dtb /boot/
sudo cp arch/arm/boot/dts/overlays/*.dtb* /boot/overlays/
sudo cp arch/arm/boot/dts/overlays/README /boot/overlays/
sudo cp arch/arm/boot/zImage /boot/$KERNEL.img
sudo reboot
</code></pre>
</li>
<li>
<h3 id="testing-the-ssd1322">Testing the ssd1322</h3>
<p>Now we’re going to test the display. If your soldering is fine and if the kernel has been built correctly, you should see the console displayed on the OLED screen but first we need to do this :</p>
<pre><code>sudo modprobe fbtft_device custom name=fb_ssd1322 width=128 height=64 speed=16000000 gpios=reset:25,dc:24
con2fbmap 1 1
</code></pre>
</li>
</ol>
<h1 id="package-installs">Package installs</h1>
<h5 id="enter-these-commands-one-by-one">Enter these commands one by one</h5>
<pre><code>curl https://keybase.io/artfwo/pgp_keys.asc | sudo apt-key add -
echo "deb https://package.monome.org/ stretch main" | sudo tee /etc/apt/sources.list.d/norns.list
</code></pre>
<pre><code>sudo apt update
sudo apt install --no-install-recommends jackd2
sudo apt-get install libboost1.62-dev
sudo apt-get install libjack-jackd2-dev
sudo apt install libmonome-dev libnanomsg-dev supercollider-language supercollider-server supercollider-supernova supercollider-dev liblua5.3-dev libudev-dev libevdev-dev liblo-dev libcairo2-dev liblua5.3-dev libavahi-compat-libdnssd-dev libasound2-dev 
sudo apt install dnsmasq
sudo apt install sc3-plugins ladspalist
sudo apt install usbmount
sudo apt-get install alsa-utils
sudo apt-get install libi2c-dev
</code></pre>
<p>Finally,  <code>sudo nano /lib/systemd/system/systemd-udevd.service</code>   and change<br>
<code>slave</code> to <code>shared</code></p>
<h1 id="audio">Audio</h1>
<ol>
<li>
<h3 id="edit--raspi-blacklist.conf">Edit  raspi-blacklist.conf</h3>
<pre><code>sudo nano /etc/modprobe.d/raspi-blacklist.conf  
</code></pre>
<p>Add</p>
<blockquote>
<pre><code>blacklist snd_bcm2835
</code></pre>
</blockquote>
</li>
<li>
<h3 id="createedit-asound.conf">Create/edit asound.conf</h3>
<pre><code>sudo nano /etc/asound.conf  
</code></pre>
<p>Add</p>
<blockquote>
<pre><code>pcm.!default  {  
 type hw card 0  
}  

ctl.!default {  
type hw card 0  
}  
</code></pre>
</blockquote>
</li>
<li>
<h3 id="edit-alsa.conf">Edit alsa.conf</h3>
<pre><code>sudo nano /usr/share/alsa/alsa.conf   
</code></pre>
<h5 id="comment-out">Comment out</h5>
<blockquote>
<pre><code>#pcm.front cards.pcm.front
#pcm.rear cards.pcm.rear
#pcm.center_lfe cards.pcm.center_lfe
#pcm.side cards.pcm.side
#pcm.surround21 cards.pcm.surround21
#pcm.surround40 cards.pcm.surround40
#pcm.surround41 cards.pcm.surround41
#pcm.surround50 cards.pcm.surround50
#pcm.surround51 cards.pcm.surround51
#pcm.surround71 cards.pcm.surround71
#pcm.iec958 cards.pcm.iec958
#pcm.hdmi cards.pcm.hdmi
#pcm.modem cards.pcm.modem
#pcm.phoneline cards.pcm.phoneline
</code></pre>
</blockquote>
</li>
</ol>
<h1 id="network-manager">Network Manager</h1>
<p>Make a quick change to network interfaces so network-manager does not take over wifi</p>
<p><strong>NOTE</strong> - <em>At the end of the network-manager install you will get kicked of off wifi and will be assigned a new IP address. You will want to have a keyboard and monitor attached here to login directly and get your IP address with <code>ifconfig</code> - or you can fake it by checking a tool like <a href="https://itunes.apple.com/us/app/lanscan/id472226235">LanScan</a> to find the device on your network.</em> <strong>Also</strong> - <em>the IP address will likely change each time you reboot.</em> <em>We will fix this at the very end of the install.</em></p>
<p><code>sudo nano /etc/network/interfaces</code></p>
<p>Add this:</p>
<blockquote>
<p><code>auto wlan0</code></p>
</blockquote>
<p>Then install network-manager and reboot</p>
<pre><code>sudo apt install network-manager
</code></pre>
<h1 id="norns-setup">Norns setup</h1>
<ol>
<li>
<h3 id="download-norns-image">Download norns image</h3>
<pre><code>git clone https://github.com/monome/norns-image.git  
cd norns-image
</code></pre>
</li>
<li>
<h3 id="edit-a-few-config-files">Edit a few config files</h3>
<p>Start by entering  this command <code>nano setup.sh</code> and comment out<br>
(<em>put a # at the beginning of)</em>  the following line:</p>
<blockquote>
<pre><code>#sudo apt install network-manager dnsmasq-base midisport-firmware 
</code></pre>
</blockquote>
<h5 id="comment-out-dhcpinterfaces-copies-so-it-does-not-hose-your-wifi-when-you-install">Comment out dhcp/interfaces copies so it does not hose your wifi when you install</h5>
<blockquote>
<pre><code>#sudo cp config/interfaces /etc/network/interfaces
</code></pre>
</blockquote>
<p>Now edit <code>nano config/norns-matron.service</code></p>
<p>And replace the line that starts with <em>ExecStart</em> with this one</p>
<pre><code>ExecStart=/home/we/norns/build/ws-wrapper/ws-wrapper ws://*:5555 /home/we/norns/build/matron/matron -f/dev/fb1
</code></pre>
<p>And now  <code>nano scripts/init-norns.sh</code>  and comment out the following lines (You might want to comment out the mixer line if you’re using a USB soundcard.)</p>
</li>
</ol>
<blockquote>
<pre><code>    #sudo i2cset -y 1 0x28 0x00 
    #sudo i2cset -y 1 0x28 0x40
    #sudo i2cset -y 1 0x29 0x00
    #sudo i2cset -y 1 0x29 0x40
</code></pre>
</blockquote>
<ol start="3">
<li>
<h3 id="create-norns-init.service">Create norns-init.service</h3>
sudo nano/etc/systemd/system/norns-init.service</li>
</ol>
<blockquote>
<pre><code>    [Unit] 
    Description=norns-init
    [Service]
    Type=oneshot
    ExecStart=/bin/sh -c "/bin/echo -n performance &gt; /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
    [Install]
    WantedBy=norns.target
</code></pre>
</blockquote>
<ol start="4">
<li>
<h3 id="add-norns-init-to-norns.target">Add norns-init to norns.target</h3>
<p><code>nano config/norns.target</code> and add above <em>norns-jack.service</em></p>
<pre><code>Requires=norns-init.service
</code></pre>
</li>
<li>
<h3 id="now-run-setup.sh">Now run <a href="http://setup.sh">setup.sh</a></h3>
<p><code>./setup.sh</code></p>
</li>
<li>
<h3 id="install-norns">Install norns</h3>
<pre><code>cd ~
git clone https://github.com/monome/norns.git
cd norns
./waf configure
./waf
</code></pre>
</li>
<li>
<h3 id="run-sclang">Run sclang</h3>
<p><code>sclang</code>  and exit with (ctrl + z)</p>
</li>
<li>
<h3 id="install-sc">Install SC</h3>
<pre><code>cd sc
./install.sh
</code></pre>
</li>
<li>
<h3 id="framebuffer-setup-for-oled">Framebuffer setup for oled</h3>
<p>Edit <em><a href="http://matron.sh">matron.sh</a></em> to add <em>-f/dev/fb1</em></p>
<p><code>sudo nano ~/norns/matron.sh</code></p>
<blockquote>
<pre><code>./build/ws-wrapper/ws-wrapper ws://*:5555 ./build/matron/matron -f/dev/fb1
</code></pre>
</blockquote>
</li>
</ol>
<h1 id="dust-and-maiden">Dust and Maiden</h1>
<p>Get dust from <a href="https://monome.nyc3.digitaloceanspaces.com/norns190405.tgz">updater</a> and transfer the folder over SFTP (using Filezilla for example) to the <em>we</em> folder on the Raspberry Pi.</p>
<p>Get maiden from github releases:<br>
<a href="https://github.com/monome/maiden/releases">https://github.com/monome/maiden/releases</a></p>
<pre><code>cd ~
wget https://github.com/monome/maiden/releases/download/v0.13/maiden-v0.13.tgz
tar -xvf maiden-v0.13.tgz
rm maiden-v0.13.tgz
</code></pre>
<h1 id="compiling-overlays">Compiling Overlays</h1>
<p>The .dts files needs to be compiled to .dtbo and then the .dtbo needs to be copied to <code>/boot/overlays/</code></p>
<p><strong>(NornsHat REV2 users only)</strong></p>
<pre><code>cd~
git clone https://github.com/nordseele/nornsHat_install_files.git
cd nornsHat_install_files
</code></pre>
<ol>
<li>
<h3 id="norns-buttons-encoders-overlay">Norns-buttons-encoders-overlay</h3>
<p><code>sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/norns-buttons-encoders.dtbo norns-buttons-encoders-overlay.dts</code></p>
</li>
<li>
<h3 id="ssd1322">Ssd1322</h3>
<p><code>sudo dtc -W no-unit_address_vs_reg -@ -I dts -O dtb -o /boot/overlays/ssd1322-spi.dtbo ssd1322-spi-overlay.dts</code></p>
</li>
<li>
<h3 id="edit-config.txt">Edit config.txt</h3>
<p>Add the reference to the overlays to  <em>/boot/config.txt</em><br>
<code>sudo nano /boot/config.txt</code></p>
<pre><code># Buttons and encoders
dtoverlay=norns-buttons-encoders
dtoverlay=ssd1322-spi
</code></pre>
</li>
</ol>
<h1 id="network--wifi">Network / Wifi</h1>
<h3 id="do-this-after-youre-screen-is-up-and-running-properly">DO THIS AFTER YOU’RE SCREEN IS UP AND RUNNING PROPERLY</h3>
<p>Reset <code>/etc/network/interfaces</code>  to norns default</p>
<pre><code>sudo cp ~/norns-linux-bits/interfaces /etc/network/interfaces
</code></pre>
<p>Rename /etc/wpa_supplicant/wpa_supplicant.conf to something else and reboot.<br>
this should get network manager to take over</p>
<pre><code>mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant_bak.conf
</code></pre>
<p>Reboot</p>
<p>At this point you will want to login to your wifi from the device screen so network manager remembers your wifi info.</p>

