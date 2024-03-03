var canvas_fa = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_fa, canvas_base.new(canvasGroup)] };
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/fa.svg", {'font-mapper': font_mapper});
		return m;
	}
};
