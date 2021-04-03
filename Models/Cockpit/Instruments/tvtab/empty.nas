var canvas_empty = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_empty] };
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "osifont-gpl2fe.ttf";
			}
		};
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
