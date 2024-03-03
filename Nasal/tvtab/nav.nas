var canvas_nav = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_nav, canvas_base.new(canvasGroup)] };
		m.heading = 0;
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/nav.svg", {'font-mapper': font_mapper});

		var svg_keys = ["heading1", "heading2", "north", "range", "kalman"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.heading2.set("clip", "rect(0, 200, 250, 110)"); #top,right,bottom,left
		m.kalman.hide();
		return m;
	},
	update1: func()
	{
		me.heading = getprop("orientation/heading-deg");
		me.heading1.setRotation(-me.heading*D2R, me.range.getCenter());
		me.north.setRotation(me.heading*D2R);
		if (me.heading < 180)
			me.heading2.setTranslation(-me.heading*3.23,0);
		else
			me.heading2.setTranslation((360-me.heading)*3.23,0);
	}
};
