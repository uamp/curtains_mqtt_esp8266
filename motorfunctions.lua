--NEEDS COMPILING

function motor_dir1()
       gpio.write(motor_en, gpio.LOW)
       gpio.write(motor_a, gpio.LOW)
       gpio.write(motor_b, gpio.HIGH)
       gpio.write(motor_en, gpio.HIGH)
       currently_moving=true
end

function  motor_dir2()
       gpio.write(motor_en, gpio.LOW)
       gpio.write(motor_b, gpio.LOW)
       gpio.write(motor_a, gpio.HIGH)
       gpio.write(motor_en, gpio.HIGH)
       currently_moving=true
end

function  motor_stop()
       current_click=0
       gpio.write(motor_en, gpio.LOW)
       gpio.write(motor_b, gpio.LOW)
       gpio.write(motor_a, gpio.LOW)
       currently_moving=false
       m:publish("home/curtains1/in",current_position,0,0, function(conn) print("sent") end)
end

function curtains_up()
        if ((current_position~="UP") and (currently_moving==false)) then
            current_click=0
            if (motor_reverse) then
                motor_dir1()
            else
                motor_dir2()
            end
            tmr.alarm( 0, emergency_stop_time, 0, motor_stop)
            current_position="UP"
        end
end

function curtains_down()
        if ((current_position~="DOWN") and (currently_moving==false)) then
            current_click=0
            if (motor_reverse) then
                motor_dir2()
            else
                motor_dir1()
            end
            tmr.alarm( 0, emergency_stop_time, 0, motor_stop)
            current_position="DOWN"
        end
end

function reed_count()
    --make sure it is definately LOW
    if (gpio.read(sw_reed)==gpio.HIGH) then return end 
    current_click=current_click+1
    print(current_click)
    if (current_click>reed_clicks) then
        motor_stop()
    end
    tmr.stop(0)
    tmr.alarm( 0, emergency_stop_time, 0, motor_stop)
end

function debounce()
    tmr.stop(2)
    tmr.alarm( 2, 20, 0, reed_count)
end

gpio.trig(sw_up, 'down', curtains_up)
gpio.trig(sw_dn, 'down', curtains_down)
gpio.trig(sw_reed,'down', debounce)
