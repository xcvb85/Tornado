var hud_sensor = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_sensor] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/hud/hud_sensor.svg");
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
