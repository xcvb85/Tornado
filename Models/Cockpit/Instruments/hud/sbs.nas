var canvas_sbs = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [canvas_sbs] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/hud/sbs.svg");
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
