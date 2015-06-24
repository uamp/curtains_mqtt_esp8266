# Curtain Controller

Curtain controller using ESP8266, nodemcu and LUA script

## Features:
* Controls curtains using a bi-directional DC motor (hooked up to H-bridge, L293D chip).  
* Uses a reed switch (attached to the lazy pulley) to count number or revolutions to determine curtain position.
* Has timeout if limit of travel reached and no reed contact seen (ie lazy pulley has stopped/jammed).
* Also has an LDR hooked up to the ADC pin and posts light level to the MQTT server.
* Manual switch that can move curtains up/down (and then posts to the MQTT server to call complete)
* WIFI reconnection and MQTT reconnection automatically.

## Listens to the following topics:
* home/curtains1/out/init - sets the initial state "UP" or "DOWN"
* home/curtains1/out - looks for "UP" or "DOWN" to drive the motor in correct direction (this links in with openhab command outputs)
* home/curtains1/out/vars/motor_reverse - "true" or "false" initial setting to change motor direction if needed
* home/curtains1/out/vars/reed_clicks - number of pulley revolutions required to open/close curtains
* home/curtains1/out/vars/emergency_stop - timeout (ms) if no reed-swtich pulse seen from lazy pulley

## Outputs to following topics:
* home/curtains/in - position of curtains after move is successful
* home/curtains/in/light_level - direct ADC read (0-1024)

## Notes:

LUA script found here, but mqtt.lua, wifi.lua and motorfunctions.lua all need to be byte compiled to .lc to work.  ESPLORER (or others) can handle this with ease.

Enter your SSID and MQTT server details and edit the pin definitions as necessary.

On initial startup it doesn't know what position the curtains are in.  This can be combatted in two ways: 
1 write to /out/init topic to tell it it's position. 
2 Send a command to move - it will assume on the first move it gets you are aware of it's initial position, so will obey blindly.  Subsequent commands will only be actioned if it is the correct place to begin with (ie, it wont try to open if already open)
