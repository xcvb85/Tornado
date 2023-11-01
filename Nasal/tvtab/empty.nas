var canvas_empty = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_empty] };
		m.group = canvasGroup;
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
