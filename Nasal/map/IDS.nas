var mapInstances = [];
var mapListener = 0;

var mapBtClick = func(index = 0, input = -1) {
}

var mapKnob = func(input = -1) {
}

mapListener = setlistener("/sim/signals/fdm-initialized", func () {

	var rpmdCanvas = canvas.new({
		"name": "RPMD",
		"size": [512, 512],
		"view": [512, 512],
		"mipmapping": 0
	});
	rpmdCanvas.setColorBackground(0, 0, 0, 1.0);
	
	var crpmdCanvas = canvas.new({
		"name": "CRPMD",
		"size": [512, 512],
		"view": [512, 512],
		"mipmapping": 0
	});
	crpmdCanvas.setColorBackground(0, 0, 0, 1.0);

	rpmdCanvas.addPlacement({"node": "RPMD.screen"});
	crpmdCanvas.addPlacement({"node": "CRPMD.screen"});
	append(mapInstances, RPMD.new(rpmdCanvas.createGroup()));
	append(mapInstances, CRPMD.new(crpmdCanvas.createGroup()));
	removelistener(mapListener);
});
