var hud_fd = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_fd] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/hud/hud_fd.svg");
		return m;
	},
	update: func()
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
