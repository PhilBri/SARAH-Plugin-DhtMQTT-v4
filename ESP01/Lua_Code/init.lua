-- init.lua for dht.lua

-- Constants
SSID    = ""
APPWD   = ""
CMDFILE = "dht.lua"

wifiTrys    = 0
NUMWIFITRYS = 200

-- Functions
function launch() 
    print("Connected to WIFI!") 
    print("IP Address: " .. wifi.sta.getip()) 
    -- Call our command file every 20 sec. 
    dofile(CMDFILE) 
    tmr.alarm(0, 20000, 1, function() dofile(CMDFILE) end ) 
end 

function checkWIFI()  
    if ( wifiTrys > NUMWIFITRYS ) then 
        print("Sorry. Not able to connect") 
    else 
        ipAddr = wifi.sta.getip() 
        if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) ) then 
            -- lauch()        -- Cannot call directly the function from here the timer... NodeMcu crashes... 
            tmr.alarm( 1 , 500 , 0 , launch ) 
        else 
            -- Reset alarm again 
            tmr.alarm( 0 , 2500 , 0 , checkWIFI) 
            print("Checking WIFI..." .. wifiTrys) 
            wifiTrys = wifiTrys + 1 
        end  
    end  
end 

 
print("-- Starting up! ")

-- Lets see if we are already connected by getting the IP 
ipAddr = wifi.sta.getip() 
if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then 
    -- We aren't connected, so let's connect 
    print("Configuring WIFI....") 
    wifi.setmode( wifi.STATION ) 
    wifi.sta.config( SSID , APPWD) 
    print("Waiting for connection") 
    tmr.alarm( 0 , 2500 , 0 , checkWIFI )  -- Call checkWIFI 2.5S in the future. 
else 
    -- We are connected, so just run the launch code.
    launch()
end 
-- Drop through here to let NodeMcu run 
            
        

