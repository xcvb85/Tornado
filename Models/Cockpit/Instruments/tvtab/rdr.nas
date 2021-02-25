var canvas_rdr = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_rdr] };
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "osifont-gpl2fe.ttf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/tvtab/rdr.svg", {'font-mapper': font_mapper});
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
