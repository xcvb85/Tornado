var canvas_eqm = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_eqm] };
		
		var font_mapper = func(family, weight)
		{
			return "Helvetica.txf";
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/eqm.svg", {'font-mapper': font_mapper});
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
