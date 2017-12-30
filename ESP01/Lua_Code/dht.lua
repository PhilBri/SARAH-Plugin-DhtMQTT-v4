-- dht.lua (Sending infos to MQTT Broker)

-- Constants
BROKER   = "m20.cloudmqtt.com"
BRPORT   = 19233
BRUSER   = "user"
BRPWD    = "password"
CLIENTID = "ESP-01"

-- DHT code
-- print('--------------- DHT INFOS --------------')
pin = 4
status, temp, humi = dht.readxx(pin)
if( status == dht.OK ) then
    tmp = cjson.encode({temperature=temp, humidity=humi, voltage=adc.readvdd33()/1000})
elseif( status == dht.ERROR_CHECKSUM ) then
    tmp = cjson.encode({error="DHT Checksum error."})
elseif( status == dht.ERROR_TIMEOUT ) then
    tmp = cjson.encode({error="DHT Time out."})
end

-- MQTT code
m = mqtt.Client( CLIENTID, 120, BRUSER, BRPWD) 

m:connect( BROKER , BRPORT, 0, function(conn)
    m:publish("ESP-01/dht", tmp, 0, 0, function(conn)
        print ("Published: "..tmp)
        -- tmr.delay(1000)
    end) 
end)
 
