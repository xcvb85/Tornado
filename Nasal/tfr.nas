var TFRInstance = {};

var TFR = {
	Info: {},
	Pos: {},
	Range: 20,
	Bottom_Left: {x:50, y:200},

	new: func(group, instance) {
		var m = {parents:[TFR]};
		m.Group = group;
		m.Instance = instance;
		#canvas.parsesvg(group, "Aircraft/Tornado/Nasal/tfr/tfr.svg");
		
		m.Input = {
			alt:	  "position/altitude-ft",
			hdg:	  "orientation/heading-deg",
			ptch:	  "orientation/pitch-deg",
		};
		foreach(var name; keys(m.Input)) {
			m.Input[name] = props.globals.getNode(m.Input[name], 1);
		}

		var x_axis = group.createChild("path", "x-axis")
									 .moveTo(m.Bottom_Left.x, m.Bottom_Left.y+3)
									 .lineTo(200, m.Bottom_Left.y+3)
									 .setColor(1,1,1)
									 .setStrokeLineWidth(3);

		m.Terrain = group.createChild("path");
		m.Index = 0;
		m.Elevation = 0;
		m.Distance = 10;
		m.Timer = maketimer(0.25, m, m.Update);
		m.Timer.start();
		return m;
	},
	Update: func()
	{
		me.Pos = geo.aircraft_position();
		me.Terrain.del();
		me.Terrain = me.Group.createChild("path");
		me.Terrain.setColor(0,1,0).setStrokeLineWidth(3);
		me.Terrain.moveTo(me.Bottom_Left.x, me.Bottom_Left.y);

		me.Pos.apply_course_distance(me.Input.hdg.getValue(), NM2M);
		for(me.Index=0; me.Index < 15; me.Index+=1) {
			me.Pos.apply_course_distance(me.Input.hdg.getValue(), 0.5*NM2M);
			me.getElevation(me.Pos.lat(), me.Pos.lon());
			me.Terrain.lineTo(me.Bottom_Left.x + 10*me.Index,
			me.Bottom_Left.y - 0.1*me.Elevation);
		}
	},
	getElevation: func(lat, lon)
	{
		me.Info = geodinfo(lat, lon);
		me.Elevation = 0;
		
		if(me.Info != nil) {
			me.Elevation = (me.Info[0] * M2FT) - (me.Input.alt.getValue()
								+ 20*me.Index*me.Input.ptch.getValue());
			
			if(me.Elevation < 0) {
				me.Elevation = 0;
			}
		}
		return me.Elevation;
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
