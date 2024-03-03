var canvas_eqm = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_eqm, canvas_base.new(canvasGroup)] };
		
		var font_mapper = func(family, weight)
		{
			return "Helvetica.txf";
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/eqm.svg", {'font-mapper': font_mapper});
		return m;
	}
};
