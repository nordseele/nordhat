# Nordhat & audio expansion board

***This project is still in development. You're building it and using it at your own risk.***

## Build and BOM

The BOM for the main board and the expansion board are located in the hardware/bom folder. Read the [notes.md](https://github.com/nordseele/nordhat/blob/master/hardware/notes.md) before ordering or soldering.

## Install instructions of specific environments
These install instructions have been tested and are provided for information purpose only.
- [Installing Norns](https://github.com/nordseele/nordhat/blob/master/install/norns/Install_instructions.md)


## Keys GPIO

- K1 : GPIO 06
- K2 : GPIO 27
- K3: GPIO 23


## Encoders GPIO

- E1A : GPIO 26  
  E1B : GPIO 13  

- E2A : GPIO 05  
  E2B : GPIO 22  

- E3A : GPIO 04  
  E3B : GPIO 17

## OLED display

- Reset : GPIO 25
- DC : GPIO 24


## UART

Using the Adafruit 954 cable:
- white lead TX
- green lead RX
- black lead GND
- ***DO NOT connect the red lead if the Pi is powered from USB !***

  `screen /dev/cu.usbserial* 115200`
