function send_temp()
    light_level=adc.read(0)
    m:publish("home/curtains1/in/lightlevel",light_level,0,0, function(conn) print("sent") end)
end
tmr.alarm( 4 , 10000, 1 , send_temp)
