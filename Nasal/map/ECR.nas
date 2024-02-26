var mapInstances = [];
var mapListener = 0;

var mapBtClick = func(index = 0, input = -1) {
}

var mapKnob = func(input = -1) {
}

mapListener = setlistener("/sim/signals/fdm-initialized", func () {

	var cedamCanvas = canvas.new({
		"name": "CEDAM",
		"size": [512, 512],
		"view": [512, 512],
		"mipmapping": 0
	});
	cedamCanvas.setColorBackground(0, 0, 0, 1.0);
	
	var crpmdCanvas = canvas.new({
		"name": "CRPMD",
		"size": [512, 512],
		"view": [512, 512],
		"mipmapping": 0
	});
	crpmdCanvas.setColorBackground(0, 0, 0, 1.0);

	cedamCanvas.addPlacement({"node": "CEDAM.screen"});
	crpmdCanvas.addPlacement({"node": "CRPMD.screen"});
	append(mapInstances, CEDAM.new(cedamCanvas.createGroup()));
	append(mapInstances, CRPMD.new(crpmdCanvas.createGroup()));
	removelistener(mapListener);
});
