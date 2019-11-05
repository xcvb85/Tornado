### Canvas EHDD ###
### xcvb 2019 ###

var EHDDInstance = {};

var PageEnum = {rdr:0
};

### EHDD ###
var EHDD = {
	new: func(group, instance) {
		var m = {parents:[EHDD], Pages:{}};
		m.Instance = instance;
		m.knob = 0;
		m.knob1 = 0;

		m.Pages[PageEnum.rdr] = canvas_rdr.new(group.createChild('group'), instance);

		setlistener("instrumentation/ehdd["~m.Instance~"]/page", func {
			var page = getprop("instrumentation/ehdd["~m.Instance~"]/page");
			m.ActivatePage(page);
		}, 1);

		m.ActivatePage(PageEnum.rdr);
		return m;
	},
	ActivatePage: func(input = -1)
	{
		for(var i=0; i<size(me.Pages); i=i+1) {
			if(i == input) {
				me.Pages[i].show();
				me.activePage = i;
			}
			else {
				me.Pages[i].hide();
			}
		}
	},
	BtClick: func(input = -1) {
	},
	Knob: func(input = -1) {
	}
};

var ehddBtClick = func(input = -1) {
	EHDDInstance.BtClick(input);
}

var ehddKnob = func(input = -1) {
	EHDDInstance.Knob(input);
}

###### Main #####
var ehddListener = setlistener("/sim/signals/fdm-initialized", func () {

	var ehddCanvas = canvas.new({
		"name": "EHDD", 
		"size": [512, 512],
		"view": [310, 250],
		"mipmapping": 1
	});
	ehddCanvas.addPlacement({"node": "EHDD.screen"});
	EHDDInstance = EHDD.new(ehddCanvas.createGroup(), 0);

	removelistener(ehddListener);
});
