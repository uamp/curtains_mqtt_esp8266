# Curtain Controller

Curtain controller using ESP8266, nodemcu and LUA script.  Primarily designed for OpenHAB, but will work with any MQTT based home automation software

## Features
* Controls curtains using a bi-directional DC motor (hooked up to H-bridge, L293D chip).  
* Uses a reed switch (attached to the lazy pulley) to count number or revolutions to determine curtain position.
* Has timeout if limit of travel reached and no reed contact seen (ie lazy pulley has stopped/jammed).
* Also has an LDR hooked up to the ADC pin and posts light level to the MQTT server.
* Manual switch that can move curtains up/down (and then posts to the MQTT server to call complete)
* WIFI reconnection and MQTT reconnection automatically.
* Compatible with any home automation software that uses MQTT (I use openhab, but any could be used)

## Software
### MQTT Topics
#### Listens to
* home/curtains1/out/init - sets the initial state "UP" or "DOWN" (command output used by openhab)
* home/curtains1/out - looks for "UP" or "DOWN" to drive the motor in correct direction (this links in with openhab command outputs)
* home/curtains1/out/vars/motor_reverse - "true" or "false" initial setting to change motor direction if needed
* home/curtains1/out/vars/reed_clicks - number of pulley revolutions required to open/close curtains
* home/curtains1/out/vars/emergency_stop - timeout (ms) if no pulse seen from the reed-switch from the lazy pulley.  If there is no reed switch installed at all, then set this to the total time required to open (or close) the curtains - the motor will just run for that time period

#### Outputs to
* home/curtains/in - position of curtains after move is successful
* home/curtains/in/light_level - direct ADC read (0-1024)

### Notes

_COMPILE:_ mqtt.lua, wifi.lua and motorfunctions.lua all need to be byte compiled to .lc to work.  ESPlorer (or others) can handle this with ease.

Enter your SSID and MQTT server details and edit the pin definitions as necessary.

On initial startup it doesn't know what position the curtains are in.  This can be combatted in two ways: 
- Write to /out/init topic to tell it it's position. 
- Send a command to move - it will assume on the first move it gets you are aware of it's initial position, so will obey blindly.  Subsequent commands will only be actioned if it is the correct place to begin with (ie, it wont try to open if already open)

## Hardware
### 3D Design/print

Hardware folder contains STL files for 3D printing for:
* Driven pulley (motor mount, and pulley with key for motor) - fits common 12v high torque motor found on ebay (picture found in the hardware folder for reference)
* Lazy pulley (mount, pulley, and end cap) - to attach at the non-working end of the curtain rail
* Lazy pulley with reed switch - allows for embeded reed switch to crudely detect rotational position


### Circuit

Circuit folder contains schematic and bread board design. It also includes Fritzing file if you want to play/edit the circuit. No PCB layout as yet as mine ended up being built on vero board.  However, this can be made from the fritzing file.

Note, the motor needs 12v, but the ESP needs 3.3v.  As it needs 700mA, best not to use a linear regulator to drop the voltage from 12v as it will get very hot.  I use a step down / buck converter which is bulkier, but more efficient.  You'll see the circuit leaves this blank for you to power as you like.

The SPDT switch needs to be a momentary switch (unlike the breadboard image) - just flick it one way or tother to move initiate curtain move.

### Pins

* H-bridge: motor a,  motor b, and motor en
* Reed switch: connect between pin and ground (uses internal pullup and interrupt routine with debouncing)
* Manual switch: SPDT: Double throw.  Ie, put common pin to ground, and either "throw" to 'swup' and 'swdown' pins on the esp respectively.  Again, internal pullup is used.
* ADC pin: Have 330/150ohm voltage dividor to bring 3.3v down to 1.1v (max reading on ESP ADC pin) then further divided that with LDR and POT to vary light dependant voltage between 0 and 1.1v.  This raw value is then put over MQTT.  A back end automation server (in my case openhab) uses this value in conjuction with knowledge of sunrise/sunset to determine if curtains should be up/down
