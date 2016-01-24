!function ($) {
    var socket;
    var register = function() {
        socket = io.connect('http://localhost:5005?clientId=DhtMQTT');

        if (!mq) {
            $('#Temp').text('MQTTHub');
            $('#Humi').text('Absent...');
        }

        socket.on('connect', function () {
            $('#Temp').text('Please');
            $('#Humi').text('wait...');

            socket.emit('publish', {topic:'ESP-01/status', payload:'?'});
            socket.emit('subscribe', {topic:'ESP-01/dht'});
            setInterval(function() {
                socket.emit('publish', {topic:'ESP-01/status', payload:'?'});
            }, tm);
        });

        socket.on('disconnect', function () {
            $('#Temp, #Humi, #Volt').text('');
        });
        
        socket.on('mqtt', function (msg) {
            var s = String.fromCharCode.apply(null, new Uint8Array(msg.payload));
            var x = jQuery.parseJSON(s);

            if (s != 'undefined') $.post('sarah/DhtMQTT?ESP='+s);
            if (x.hasOwnProperty('error')) {
                $('#Temp').text('Sensor');
                $('#Humi').text('error');
            } else {
                $('#Temp').text(x.temperature.toFixed(1) + '°C');
                $('#Humi').text(x.humidity.toFixed(1) + ' %');
                $('#Volt').text(x.voltage + ' V');
            }
        });
    }

    $(document).ready( function() {
        register();
    });
  
} (jQuery);
