var HUDInstance = {};

var PageEnum = {
    dir:0
};

var HUD = {
	new: func(group, instance) {
		var m = {parents:[HUD], Pages:{}};
		m.Instance = instance;
		m.knob = 0;
		m.knob1 = 0;

		m.PageSbs = canvas_sbs.new(group.createChild('group'), instance);
		m.Pages[PageEnum.dir] = canvas_dir.new(group.createChild('group'), instance);

		setlistener("instrumentation/hud["~m.Instance~"]/page", func {
			var page = getprop("instrumentation/hud["~m.Instance~"]/page");
			m.ActivatePage(page);
		}, 1);

		m.ActivatePage(PageEnum.dir);
		return m;
	},
	ActivatePage: func(input = -1)
	{
		for(var i=0; i < size(me.Pages); i=i+1) {
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

var hudBtClick = func(input = -1) {
	HUDInstance.BtClick(input);
}

var hudKnob = func(input = -1) {
	HUDInstance.Knob(input);
}

###### Main #####
var hudListener = setlistener("/sim/signals/fdm-initialized", func () {

	var hudCanvas = canvas.new({
		"name": "HUD_Screen", 
		"size": [1024, 1024],
		"view": [256, 256],
		"mipmapping": 1
	});
	hudCanvas.addPlacement({"node": "HUD_Screen"});
	hudCanvas.setColorBackground(0, 0, 0, 0);
	HUDInstance = HUD.new(hudCanvas.createGroup(), 0);

	removelistener(hudListener);
});
