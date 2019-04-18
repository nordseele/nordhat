# Notes

# Before you start...
We do not provide a "step by step build guide" for this project. There are only a few components and we assume you have a prior experience building electronic projects, soldering, etc. You'll find the references on the silkscreen and in the BOM and some additional tips and explanations in this page. The "hardware part" of the construction might require further experimentation/tricks. For example you'll probably need to adjust the height of the spacers if you choose to use a 3mm panel instead of a 2mm one. All the things learned and tested during the construction of this prototype are reflected here. If you choose another component that the one listed in the suggested BOM (encoders, jack connectors, etc) you should verify that the footprint matches and pinout matches, it is at your own risk. *Think "DIY" and use common sense.*

---

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

It is recommended to use a screen protection made of Perspex/ plexiglas. Less than 1mm thick. It is placed between the top panel and the display. Use double sided adhesive tape to attach it. I used a small photo frame from Ikea from which I cut the plexiglas to size, cheapest solution, less than 2 euros. The dimensions should be 4cm x 7cm maximum.

## Spacers / standoff

### With expansion board

TBD

### Without expansion board
| holes (h) | position | length  | type  | thread | quantity |
| :---: | :---: |:-------: | :-----: | :------: | :--------: |
| 1, 2, 3, 4 | top | 15mm   | MF  | M3 | 4 |
| 1, 2, 3, 4 | bottom | 8mm   |  MM | M3  | 4 |

### Additional hardware needed to attach the standoffs and panels together
- Headless screws M3 10mm  
- Flat head screws M3 10mm (Use normal head if your top panel doesn't have countersunk holes)
- M3 nylon washers
- M2.5 nuts

##### Further notes about the spacers
The Nord Hat prototype use rounded  steel spacers of the WA-SMSI series made by Würth Elektronik. If you wish to use them, you will need to drill some mounting holes of the PCB (diameter 4.4mm H1, 2, 3, 4). Do this at your own risk even though there are no traces passing too close from these holes and there's an additional margin of error of 1mm. Beware if you order these spacers, they have a thinner 1mm high ring on top, the height of this ring supposed to be inserted into the mounting hole is not taken into account in the reference, that means that the WA-SMSI 15mm standoff/spacer is actual 15mm + 1mm (16mm). Same goes for all the references of this series (see data sheet of the manufacturer for more information).     
____

### Issues

If you encounter an hardware issue, check your soldering and reflow if necessary. Otherwise, create an issue in this repository. Questions related to installing Norns or any other environment should be posted to their respective repositories/forum/creators, the install instructions of the Norns environment that are provided in this repository have been tested but are only here for information purposes. The Raspberry Pi GPIO used for connecting the encoders, keys, OLED of this board are listed in readme.md. Two overlay .dts files are provided in the "overlays" folder.
