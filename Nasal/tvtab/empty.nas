var canvas_empty = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_empty, canvas_base.new(canvasGroup)] };
		return m;
	}
};
