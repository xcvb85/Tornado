var ndlayers = [{name:'APT',style:{scale_factor:0.3,label_font_color:[0,1,0],color_default:[0,1,0],line_width:2}},
		{name:'DME',style:{scale_factor:0.3,color_default:[0,1,0],line_width:2}},
		{name:'WPT',style:{scale_factor:0.3,color:[0,1,0],line_width:2}},
		{name:'RTE',style:{scale_factor:0.3,color:[0,1,0],line_width:2}}];

var canvas_plan = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_plan] };
		m.map = canvasGroup.createChild('map');

		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "osifont-gpl2fe.ttf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/tvtab/plan.svg", {'font-mapper': font_mapper});
		m.group = canvasGroup;
		
		m.map.setController("Aircraft position");
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
