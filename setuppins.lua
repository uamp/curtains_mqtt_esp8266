motor_en=6 --io12 (blue on dev)
motor_a=5 -- io14 (white on dev)
motor_b=1 -- io5 (buzzer on dev)
sw_up=4 --io2 (s3 on dev)
sw_dn=2 --io4 (DHT11 on dev)
sw_reed=7 --io13 (green on dev)
--sw_reed=3 --sw2 on dev

gpio.mode(motor_en,gpio.OUTPUT)
gpio.write(motor_en, gpio.LOW)
gpio.mode(motor_a,gpio.OUTPUT)
gpio.write(motor_a, gpio.LOW)
gpio.mode(motor_b,gpio.OUTPUT)
gpio.write(motor_b, gpio.LOW)

gpio.mode(sw_up,gpio.INPUT,gpio.PULLUP)
gpio.mode(sw_dn,gpio.INPUT,gpio.PULLUP)

current_position="UNKNOWN" --in due course will change the way this activates
if(gpio.read(sw_up)==0) then
    current_position="UP"
end
if(gpio.read(sw_dn)==0) then
    current_position="DOWN"
end

gpio.mode(sw_up,gpio.INT,gpio.PULLUP)
gpio.mode(sw_dn,gpio.INT,gpio.PULLUP)

gpio.mode(sw_reed,gpio.INT,gpio.PULLUP)

current_click=0
currently_moving=false
