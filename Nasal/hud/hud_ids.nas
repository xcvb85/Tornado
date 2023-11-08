var HUDInstance = {};

var ModeEnum = {
	MODE_OFF: 0,
	MODE_DIRECT: 1,
	MODE_AUTO: 2,
	MODE_NAV: 3,
	MODE_TEST2: 4,
	MODE_TEST1: 5,
	NUM_MODES: 6
};

var PageEnum = {
	PAGE_EMPTY: 0,
	PAGE_FD: 1,
	PAGE_CCIP: 2,
	PAGE_GUN: 3,
	NUM_PAGES: 4
};

var HUD = {
	new: func(group, instance) {
		var m = {parents:[HUD], Pages: [], vv_dir: [], SelectedWeapon: {}};
		m.Instance = instance;
		
		# HUD .ac coords:    upper-left                 lower-right        
		HudMath.init([-4.732,-0.075,-0.0854], [-4.817,0.080,-0.209], [1024,1024], [0,1.0], [1,0.0], 0);

		m.PageSbs = hud_sbs.new(group.createChild('group'), instance);
		m.GroupHud = group.createChild('group');
		m.PageBase = hud_base.new(m.GroupHud, instance);
		
		setsize(m.Pages, PageEnum.NUM_PAGES);
		m.Pages[PageEnum.PAGE_EMPTY] = hud_empty.new(m.GroupHud.createChild('group'), instance);
		m.Pages[PageEnum.PAGE_FD] = hud_fd.new(m.GroupHud.createChild('group'), instance);
		m.Pages[PageEnum.PAGE_CCIP] = hud_ccip.new(m.GroupHud.createChild('group'), instance);
		m.Pages[PageEnum.PAGE_GUN] = hud_gun.new(m.GroupHud.createChild('group'), instance);

		m.swMode = props.globals.getNode("instrumentation/hud/swMode");
		m.swSbs = props.globals.getNode("instrumentation/hud/swSbs");

		m.ActivePage = -1;
		m.NewPage = -1;
		m.Mode = 0;
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

		if(me.Mode > ModeEnum.MODE_OFF) {
			me.GroupHud.show();
			me.vv_dir = me.PageBase.update();
			me.NewPage = PageEnum.PAGE_EMPTY;
			
			if(me.Mode == ModeEnum.MODE_AUTO) {
				me.SelectedWeapon = pylons.fcs.getSelectedWeapon();
				
				if(me.SelectedWeapon != nil) { #and me.input.MasterArm.getValue()
					if(me.SelectedWeapon.type == "MK-82" or me.SelectedWeapon.type == "MK-82AIR") {
						me.NewPage = PageEnum.PAGE_CCIP;
					}
					else {
						me.NewPage = PageEnum.PAGE_GUN;
					}
				}
				else {
					me.NewPage = PageEnum.PAGE_FD;
				}
			}
			else if(me.Mode == ModeEnum.MODE_NAV) {
				me.NewPage = PageEnum.PAGE_FD;
			}
			
			if(me.NewPage != me.ActivePage) {
				me.ActivatePage(me.NewPage);
			}
			me.ActivePage = me.NewPage;
			me.Pages[me.ActivePage].update(me.vv_dir[0], me.vv_dir[1]);
		}
		else {
			me.ActivePage = -1;
			me.GroupHud.hide();
		}
		
		if((me.swSbs.getValue() or 0) > 0) {
			me.PageSbs.show();
		}
		else {
			me.PageSbs.hide();
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
