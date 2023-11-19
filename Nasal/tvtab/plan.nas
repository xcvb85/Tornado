var ndlayers = [{name:'APT_to',style:{scale_factor:0.3,label_font_color:[0,1,0],color_default:[0,1,0],line_width:3}},
		{name:'APS_to',style:{scale_factor:0.3,color:[0,1,0],line_width:5}},
		{name:'CUR_to',style:{scale_factor:0.3,color:[0,1,0],line_width:5}},
		{name:'DME_to',style:{scale_factor:0.3,color_default:[0,1,0],line_width:3}},
		{name:'WPT_to',style:{scale_factor:0.3,color:[0,1,0]}},
		{name:'CST_to',style:{scale_factor:0.3,color:[0,1,0],line_width:1}}];

var lon = props.globals.getNode("position/longitude-deg");
var lat = props.globals.getNode("position/latitude-deg");

var tvtab_controller = {
	parents: [canvas.Map.Controller],

	new: func(map) {
		var m = { parents: [tvtab_controller],
			map: map,
			apt: map.getLayer('APT_to'),
			aps: map.getLayer('APS_to'),
			wpt: map.getLayer('WPT_to'),
			rte: map.getLayer('RTE_to')
		};
		m.map.setPos(lat.getValue(), lon.getValue(), 0);
		m.timer = maketimer(0.2, m, m.update);
		m.timer.start();
		return m;
	},
	update: func() {
		me.map.update();
	}
};

var canvas_plan = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_plan] };
		m.map = canvasGroup.createChild('map');

		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/plan.svg", {'font-mapper': font_mapper});
		m.group = canvasGroup;

		var ctrl_ns = canvas.Map.Controller.get("Aircraft position");
		var source = ctrl_ns.SOURCES["to-map"];
		if (source == nil) {
			var source = ctrl_ns.SOURCES["to-map"] = {
			getPosition: func subvec(geo.aircraft_position().latlon(), 0, 2),
			getAltitude: func getprop('/position/altitude-ft'),
			getHeading:  func { 0 },
			aircraft_heading: 1,
			};
		}

		m.map.setController(tvtab_controller);
		m.map.setRange(50);
		m.map.setTranslation(155, 125);

		foreach(var layer; ndlayers) {
			m.map.addLayer(
				factory: canvas.SymbolLayer,
				type_arg: layer.name,
				visible: 1,
				style: layer.style,
				priority: layer['z-index']
			);
		}

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
