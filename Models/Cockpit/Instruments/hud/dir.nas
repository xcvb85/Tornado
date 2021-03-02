var canvas_dir = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [canvas_dir] };
		m.group = canvasGroup;
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/hud/hud.svg");
		
		var svg_keys = ["heading", "ladder"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.heading.set("clip", "rect(0, 169, 256, 69)"); #top,right,bottom,left
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
