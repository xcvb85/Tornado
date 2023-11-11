var TFRInstance = {};

var TFR = {
	new: func(group, instance) {
		var m = {parents:[TFR], Info: {}, Pos: {}};
		m.Instance = instance;
		canvas.parsesvg(group, "Aircraft/Tornado/Nasal/tfr/tfr.svg");
		
		m.Input = {
			hdg:      "orientation/heading-deg",
		};
		foreach(var name; keys(m.Input)) {
			m.Input[name] = props.globals.getNode(m.Input[name], 1);
		}

		m.Tmp = 0;
		m.Distance = 10;
		m.Timer = maketimer(0.25, m, m.Update);
		m.Timer.start();
		return m;
	},
	Update: func()
	{
		me.Pos = geo.aircraft_position();
		me.Pos.apply_course_distance(me.Input.hdg.getValue(), 10*NM2M);
		print(me.getElevation(me.Pos.lat(), me.Pos.lon()));
	},
	getElevation: func(lat, lon)
	{
		me.Info = geodinfo(lat, lon);
		if (me.Info != nil) {
			me.Tmp = me.Info[0] * M2FT;
		}
		else {
			me.Tmp = -1.0;
		}
		return me.Tmp;
	}
};

var tfrListener = setlistener("/sim/signals/fdm-initialized", func () {
	var tfrCanvas = canvas.new({
		"name": "TFR_Screen", 
		"size": [1024, 1024],
		"view": [256, 256],
		"mipmapping": 1
	});
	tfrCanvas.addPlacement({"node": "ESRRD.screen"});
	tfrCanvas.setColorBackground(0, 0, 0, 0);
	TFRInstance = TFR.new(tfrCanvas.createGroup(), 0);
	removelistener(tfrListener);
});
