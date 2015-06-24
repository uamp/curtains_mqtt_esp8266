--NEEDS COMPILING

-- init mqtt client with keepalive timer 120sec
-- edit connection details - line 14 and 52 as required

function subscribef()
   print("mqtt connected")
   m:subscribe("home/curtains1/out/#",0, function(conn) print("subscribe success") end)
   dofile("adc.lua")
end

function reconnect()
    if(wifi.sta.status()==5) then
        m:connect("192.168.1.5", 1883, 0, function(conn) subscribef() end)     
        tmr.stop(3)
    end
end

m = mqtt.Client("curtains1", 120, "user", "password")
m:on("connect", function(con) print ("connected") end)
m:on("offline", function(con) print("mqtt offline") tmr.alarm( 3 , 4000 , 1 , reconnect)  end)
m:on("message", function(conn, topic, data)
  print(topic .. ":")
  if data ~= nil then
    print(data)
    if topic=="home/curtains1/out" then      
        if(data=="UP")then
            curtains_up()
        elseif(data=="DOWN")then 
            curtains_down()
        end
     elseif topic=="home/curtains1/out/init" then
        current_position=data
     else
        file.open("vars.lua","a+")
         if topic=="home/curtains1/out/vars/reed_clicks" then
            file.writeline("reed_clicks="..data)
            reed_clicks=data
         elseif topic=="home/curtains1/out/vars/emergency_stop_time" then
            file.writeline("emergency_stop_time="..data)
            emergency_stop_time=data
         elseif topic=="home/curtains1/out/vars/motor_reverse" then
            file.writeline("motor_reverse="..data)
            motor_reverse=data        
         end
         file.close()
      end
  end
end)

--edit following line as required
m:connect("192.168.1.5", 1883, 0, function(conn) subscribef() end)


