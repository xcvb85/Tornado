var canvas_nav = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_nav] };
		m.group = canvasGroup;
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/tvtab/nav.svg", {'font-mapper': font_mapper});

		var svg_keys = ["heading", "north", "range", "kalman"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.north.setDrawMode(canvas.Text.TEXT + canvas.Text.FILLEDBOUNDINGBOX);
		m.north.setColor(0,0,0).setColorFill(0,255,0);
		m.kalman.hide();
		m.timer = maketimer(0.1, m, m.update);
		return m;
	},
	update: func()
	{
		me.heading.setRotation(-getprop("orientation/heading-deg")*D2R, me.range.getCenter());
		me.north.setRotation(getprop("orientation/heading-deg")*D2R);
	},
	show: func()
	{
		me.update();
		me.timer.start();
		me.group.show();
	},
	hide: func()
	{
		me.timer.stop();
		me.group.hide();
	}
};
