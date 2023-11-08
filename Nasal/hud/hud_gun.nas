var hud_gun = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_gun] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/hud/hud_gun.svg");
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
