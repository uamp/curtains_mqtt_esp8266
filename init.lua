dofile("setuppins.lua")  --also has a copy of the motor timings in it
dofile("motorfunctions.lc")
if(file.open("vars.lua","r")~=nil) then
    file.close()
    dofile("vars.lua") --update motor timings if file exists
end
dofile("wifi.lc")
