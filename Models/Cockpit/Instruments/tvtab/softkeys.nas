var canvas_softkeys = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_softkeys] };
		m.i = 0;
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "osifont-gpl2fe.ttf";
			}
		};
		
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/tvtab/softkeys.svg", {'font-mapper': font_mapper});

		var svg_keys = ["sk0","sk1","sk2","sk3","sk4","sk5","sk6","sk7","sk8","sk9"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
			m[key].setDrawMode(canvas.Text.TEXT + canvas.Text.FILLEDBOUNDINGBOX);
		}
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
	}
};
