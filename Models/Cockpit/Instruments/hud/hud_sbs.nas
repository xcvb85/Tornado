var hud_sbs = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_sbs] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/hud/hud_sbs.svg");
		return m;
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
