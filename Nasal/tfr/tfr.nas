var TFRInstance = {};

var TFR = {
	new: func(group, instance) {
		var m = {parents:[TFR]};
		m.Instance = instance;
		canvas.parsesvg(group, "Aircraft/Tornado/Nasal/tfr/tfr.svg");
		return m;
	}
};

var tfrListener = setlistener("/sim/signals/fdm-initialized", func () {
	var tfrCanvas = canvas.new({
		"name": "TFR_Screen", 
		"size": [1024, 1024],
		"view": [256, 256],
		"mipmapping": 1
	});
	tfrCanvas.addPlacement({"node": "ESRRD.screen"});
	tfrCanvas.setColorBackground(0, 0, 0, 0);
	TFRInstance = TFR.new(tfrCanvas.createGroup(), 0);
	removelistener(tfrListener);
});
