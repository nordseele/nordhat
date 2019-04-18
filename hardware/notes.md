# Notes

## Headers and card to card connectors

### J3, J7, J6 - The I2C section (middle/top of the board)
It's probably better to ***avoid soldering these connectors at the moment if you don't know what you're doing***, don't solder/order J3,J7,J6. This can be done later. At the moment this section has not been tested and has no utility. If you choose to solder the jack connector despite this recommendation, you should NEVER connect a midi jack or audio jack to this plug. If you solder the stereo jack connector, it can be soldered either on top or on the bottom of the board (see silkscreen) but it's recommended to solder it on the bottom.

### J4 - UART 4 pins angled header
If you're not planning to use the UART header, don't solder/order J4, it can also be done later if you change your mind. If you solder it on, this header should be placed/soldered on top of the board (even if the silkscreen is printed on the bottom)

### J2, 02x07 pins - expansion board header
If you're planning to use the audio expansion board or if you need to access the GPIO )written on the bottom silkscreen) for any other purpose, ***you should solder this 14 positions 2 rows header before you solder the OLED display. It would be impossible or very difficult to solder this afterwards.***


## Spacers / standoff

To be determined


### Issues

If you encounter an hardware issue, check your soldering and reflow if necessary. Otherwise, create an issue in this repository. Questions related to installing Norns or any other environment should be posted to their respective repositories/forum/creators. The Raspberry Pi GPIO used for connecting the encoders, keys, OLED of this board are listed in readme.md. Two overlay .dts files are provided in the "overlays" folder 
