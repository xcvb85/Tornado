var hud_ccip = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_ccip] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/hud/hud_ccip.svg");
		return m;
	},
	update: func(dir_x, dir_y)
	{
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
