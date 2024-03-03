var canvas_rdr = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_rdr, canvas_base.new(canvasGroup)] };

		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/rdr.svg", {'font-mapper': font_mapper});

		var svg_keys = ["horizonBar"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		return m;
	},
	update: func()
	{
		me.horizonBar.setRotation(-getprop("orientation/roll-deg")*D2R, me.horizonBar.getCenter());
	}
};
