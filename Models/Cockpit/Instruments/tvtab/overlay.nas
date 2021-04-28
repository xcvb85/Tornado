var canvas_overlay = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_overlay] };
		m.i = 0;
		m.text = "";
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};
		
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/tvtab/overlay.svg", {'font-mapper': font_mapper});

		var keys = ["time","scratchpad"];
		foreach(var key; keys) {
			m[key] = canvasGroup.getElementById(key);
			m[key].setColor(0,255,0);
		}
		m.scratchpad.setText("");
		m.time.setText(getprop("sim/time/local-time-string"));

		var svg_keys = ["sk0","sk1","sk2","sk3","sk4","sk5","sk6","sk7","sk8","sk9"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
			m[key].setDrawMode(canvas.Text.TEXT + canvas.Text.FILLEDBOUNDINGBOX);
		}
		m.timer = maketimer(1.0, m, m.update);
		m.timer.start();
		return m;
	},
	setSoftkeys: func(softkeys, selectedSoftkeys)
	{
		for(me.i = 0; me.i < 10; me.i+=1) {
			if(selectedSoftkeys[me.i] == 1) {
				me["sk"~(me.i)].setText(softkeys[me.i]).setColor(0,0,0).setColorFill(0,255,0);
			}
			else {
				me["sk"~(me.i)].setText(softkeys[me.i]).setColor(0,255,0).setColorFill(0,0,0);
			}
		}
	},
	setCharacter: func(character)
	{
		if(character != nil) {
			me.text = me.text~character;
			me.scratchpad.setText(me.text);
		}
	},
	setText: func(text)
	{
		me.scratchpad.setText(text);
	},
	update: func
	{
		me.time.setText(getprop("sim/time/local-time-string"));
	}
};
