var values = {};
exports.action = function(data, next){
	if (data.hasOwnProperty('ESP')) values = JSON.parse(data.ESP); 
	if (data.hasOwnProperty('tts')) {
		if (data.key == "temperature") data.tts = data.tts.replace("§",values.temperature).replace('.', ',');
		else if (data.key == "humidity") data.tts = data.tts.replace("§",values.humidity).replace('.', ',');
		else if (data.key == "voltage") data.tts = data.tts.replace("§",values.voltage).replace('.', ',');
	}
	next({});
}

exports.init = function(){
  info('Plugin DhtMQTT is initializing ...');
}
