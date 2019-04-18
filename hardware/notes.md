# Notes

## Headers and card to card connectors

![alt text](https://github.com/nordseele/nordhat/blob/master/hardware/images/mockup_nordhat.png "mockup headers and mounting holes")


### J3, J7, J6 - The I2C section (middle/top of the board)
It's probably better to ***avoid soldering these connectors at the moment if you don't know what you're doing***, don't solder/order J3,J7,J6. This can be done later. At the moment this section has not been tested and has no utility. If you choose to solder the jack connector despite this recommendation, you should ***NEVER connect a midi jack or audio jack to this plug***. If you solder the stereo jack connector, it can be soldered either on top or on the bottom of the board (see silkscreen) but it's recommended to solder it on the bottom. For J7 and J6, cut two pins from a male 2.54 breakable pin strip like the reference suggested. (Order only one if you order the Adafruit 392, it’s a pack of 10 pieces)

### J4 - UART 4 pins angled header
If you're not planning to use the UART header, don't solder/order J4, it can also be done later if you change your mind. If you solder it on, this header should be placed/soldered on top of the board (even if the silkscreen is printed on the bottom). This header can be used with the Adafruit 954 cable. You should ***NEVER CONNECT THE 5V pin if the Raspberry Pi is powered via USB.***

### J2, 02x07 pins - expansion board header
If you're planning to use the audio expansion board or if you need to access the GPIO )written on the bottom silkscreen) for any other purpose, ***you should solder this 14 positions 2 rows header before you solder the OLED display. It would be impossible or very difficult to solder this afterwards.***
### J5 - OLED Header
Cut twenty pins from a male 2.54 breakable pin strip (see Adafruit 392 pack, as mentioned above)


## Buttons and encoders

### Buttons / Key switches
We’re using low actuation force key switches, but feel free to use another actuation force, in the same APEM 5E series. Note that you could use the 5G series which has the same footprint and a larger choice of caps available, but you'll have to modify the cutout (larger holes) of the top panel in consequence.

#### Button caps
1SS, the only caps available for the 5E series. They're  available in multiple colors and height. read the data sheet of the manufacturer to find out how to adjust the reference. Adjust height depending on the thickness of the panel etc. Try multiple heights eventually. ***These caps are made for the APEM 5E series ONLY***.

### Encoders
We’re using encoders without detent and without switch with T18 shaft. The shortest available in this series.
Use PEC11R-4015F-N0024 if you want a D-Shaft terminaison.
#### Encoder knobs
Use what you want, modify your choice of encoder/shaft terminaison in consequence. The encoders knobs used on the "Nord Hat" prototype are not available to buy.  

## Screen protection

To be determined

## Spacers / standoff

To be determined

____

### Issues

If you encounter an hardware issue, check your soldering and reflow if necessary. Otherwise, create an issue in this repository. Questions related to installing Norns or any other environment should be posted to their respective repositories/forum/creators, the install instructions of the Norns environment that are provided in this repository have been tested but are only here for information purposes. The Raspberry Pi GPIO used for connecting the encoders, keys, OLED of this board are listed in readme.md. Two overlay .dts files are provided in the "overlays" folder.
