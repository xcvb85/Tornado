var canvas_rdr = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [canvas_rdr] };
		m.group = canvasGroup;
		m.Instance = instance;
		m.Id = instance;

		var font_mapper = func(family, weight)
		{
			return "honeywellfont.ttf";
		};
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/ehdd/rdr.svg", {'font-mapper': font_mapper});

		var svg_keys = ["horizonBar"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		return m;
	},
	update: func() {
	},
	BtClick: func(input = -1) {
		me.update();
	},
	Knob: func(index = -1, input = -1) {
		me.update();
	},
	show: func()
	{
		me.update();
		me.group.show();
	},
	hide: func()
	{
		me.group.hide();
	}
};
