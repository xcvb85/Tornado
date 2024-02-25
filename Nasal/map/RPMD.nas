var RpmdInstances = [];

var rpmdListener = 0;

var RPMD = {
	new: func(group, instance)
	{
		var m = { parents: [RPMD] };
		return m;
	}
};

var rpmdBtClick = func(index = 0, input = -1) {
}

var rpmdKnob = func(input = -1) {
}

rpmdListener = setlistener("/sim/signals/fdm-initialized", func () {

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
	append(RpmdInstances, MM.new(rpmdCanvas.createGroup(), 0));
	append(RpmdInstances, MM.new(crpmdCanvas.createGroup(), 0));
	removelistener(rpmdListener);
});
