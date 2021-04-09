var ndlayers = [{name:'APT_to',style:{scale_factor:0.3,label_font_color:[0,1,0],color_default:[0,1,0],line_width:2}},
		{name:'WPT_to',style:{scale_factor:0.3,color:[0,1,0]}},
		{name:'RTE',style:{scale_factor:0.3,color:[0,1,0],line_width:1}}];

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
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/tvtab/plan.svg", {'font-mapper': font_mapper});
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

		m.map.setController("Aircraft position", "to-map");
		m.map.setRange(25);
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
