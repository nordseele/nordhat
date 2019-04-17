# Nordhat & audio expansion board

## Install instructions

- [Installing Norns](https://github.com/nordseele/nordsHat/blob/master/install/norns/Install_instructions.md)



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
- ***DO NOT connect the red lead while the Pi is still powered from USB !***

  `screen /dev/cu.usbserial* 115200`

## I2C

The I2C output over stereo jack connector on top of the board has not been tested yet and has no utility at the moment. DO NOT use it unless you know what you're doing.
____
### Todo

Adjust instructions for expansion board  
Add build instructions ?  
