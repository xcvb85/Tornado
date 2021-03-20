var HUDInstance = {};

var PageEnum = {
	dir:0
};

var HUD = {
	new: func(group, instance) {
		var m = {parents:[HUD], Pages:{}};
		m.Instance = instance;

		m.PageSbs = canvas_sbs.new(group.createChild('group'), instance);
		m.Pages[PageEnum.dir] = canvas_dir.new(group.createChild('group'), instance);

		m.swMode = props.globals.getNode("instrumentation/hud/swMode");
		m.swSbs = props.globals.getNode("instrumentation/hud/swSbs");

		m.PageSbs.hide();
		m.ActivatePage();
		m.Timer = maketimer(0.2, m, m.Update);
		m.Timer.start();
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
	Update: func()
	{
		if(me.swMode.getValue()) {
			me.ActivatePage(0);
		}
		else {
			me.ActivatePage();
		}

		if(me.swSbs.getValue()) {
			me.PageSbs.show();
		}
		else {
			me.PageSbs.hide();
		}
	}
};

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
