var HUDInstance = {};

var ModeEnum = {
	off: 0,
	on: 1,
	dcl: 2,
	em: 3,
	t2: 4,
	t1: 5
};

var PageEnum = {
	empty: 0,
	fd: 1,
	gun: 2
};

var HUD = {
	new: func(group, instance) {
		var m = {parents:[HUD], Pages:{}};
		m.Instance = instance;

		m.Sbs = hud_sbs.new(group.createChild('group'), instance);
		m.Hud = hud_base.new(group.createChild('group'), instance);
		m.Pages[PageEnum.empty] = hud_empty.new(group.createChild('group'), instance);
		m.Pages[PageEnum.fd] = hud_fd.new(group.createChild('group'), instance);
		m.Pages[PageEnum.gun] = hud_gun.new(group.createChild('group'), instance);

		m.swMode = props.globals.getNode("instrumentation/hud/swMode");
		m.swSbs = props.globals.getNode("instrumentation/hud/swSbs");

		m.ActivePage = -1;
		m.ActivatePage();
		m.Update();
		m.Timer = maketimer(0.1, m, m.Update);
		m.Timer.start();
		return m;
	},
	ActivatePage: func(input = -1)
	{
		me.ActivePage = -1;
		for(var i=0; i < size(me.Pages); i=i+1) {
			if(i == input) {
				me.Pages[i].show();
				me.ActivePage = i;
			}
			else {
				me.Pages[i].hide();
			}
		}
	},
	Update: func()
	{
		me.Mode = me.swMode.getValue() or 0;
		
		if(me.Mode > ModeEnum.off) {
			me.Hud.show();
			me.Hud.update();
			me.NewPage = PageEnum.empty;
			
			if(me.Mode == ModeEnum.on) {
				me.NewPage = PageEnum.gun;
			}
			
			if(me.NewPage != me.ActivePage) {
				me.ActivatePage(me.NewPage);
			}
			me.ActivePage = me.NewPage;
			me.Pages[me.ActivePage].update();
		}
		else {
			me.ActivePage = -1;
			me.Hud.hide();
		}

		if(me.swSbs.getValue()) {
			me.Sbs.show();
		}
		else {
			me.Sbs.hide();
		}
	}
};

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
