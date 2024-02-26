var CRPMD = {
	new: func(canvasGroup)
	{
		var m = { parents: [CRPMD] };
		m.MM = MM.new(canvasGroup.createChild('group'));
		
		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};
		canvas.parsesvg(canvasGroup.createChild('group'), "Aircraft/Tornado/Nasal/map/crpmd.svg", {'font-mapper': font_mapper});
		return m;
	}
};
