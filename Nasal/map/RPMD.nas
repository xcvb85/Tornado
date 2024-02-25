var RpmdInstances = [];

var rpmdListener = 0;

var RPMD = {
	new: func(canvasGroup)
	{
		var m = { parents: [RPMD] };
		m.MM = MM.new(canvasGroup.createChild('group'));
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};
		canvas.parsesvg(canvasGroup.createChild('group'), "Aircraft/Tornado/Nasal/map/cedam.svg", {'font-mapper': font_mapper});
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
	append(RpmdInstances, RPMD.new(rpmdCanvas.createGroup()));
	append(RpmdInstances, MM.new(crpmdCanvas.createGroup()));
	removelistener(rpmdListener);
});
