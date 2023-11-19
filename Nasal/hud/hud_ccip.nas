var hud_ccip = {
	CCIP: [],
	Coords: [],

	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_ccip] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/hud/hud_ccip.svg");

		var svg_keys = ["pipper"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.Line = m.group.createChild("path");
		return m;
	},
	update: func(dir_x, dir_y)
	{
		if(me.Line != nil) {
			me.Line.del();
		}
		
		me.CCIP = pylons.fcs.getSelectedWeapon().getCCIPadv(16,0.1);
		if(me.CCIP != nil) {
			me.Coords = HudMath.getPosFromCoord(me.CCIP[0]);
			
			if(me.Coords[1] > 0) {
				me.Line = me.group.createChild("path");
				me.Line.setColor(0,1,0).setStrokeLineWidth(2);
				me.Line.moveTo(120 + dir_x, 128 + dir_y);
				me.Line.lineTo(120 + me.Coords[0], 128 + me.Coords[1]);
				me.pipper.show();
				me.pipper.setTranslation(me.Coords[0], me.Coords[1]);
			}
			else {
				me.pipper.hide();
			}
		}
	},
	show: func()
	{
		me.group.show();
	},
	hide: func()
	{
		me.group.hide();
	}
};
