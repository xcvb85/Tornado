var canvas_overlay = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_overlay], chr_data:[], fp:{}, wp:{} };
		m.fp = flightplan();
		m.text = "";
		m.mode = 0;
		m.tmp1 = 0;
		m.tmp2 = 0;
		m.tmp3 = 0;
		m.counter = 0;
		setsize(m.chr_data,30);
		
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
		for(me.tmp1 = 0; me.tmp1 < 10; me.tmp1+=1) {
			if(selectedSoftkeys[me.tmp1] == 1) {
				me["sk"~(me.tmp1)].setText(softkeys[me.tmp1]).setColor(0,0,0).setColorFill(0,255,0);
			}
			else {
				me["sk"~(me.tmp1)].setText(softkeys[me.tmp1]).setColor(0,255,0).setColorFill(0,0,0);
			}
		}
	},
	setCharacter: func(character) {
		if(character != nil and size(character) == 1) {
			if(me.mode == 1) {
				# waypoint
				if(character == "\n") {
					# enter
					me.text = "";
					me.counter = 0;
					
					for(me.tmp1=2; me.tmp1 < 7; me.tmp1+=1) {
						if(me.chr_data[me.tmp1] != nil) {
							me.text = me.text~chr(me.chr_data[me.tmp1]);
						}
					}
					if(me.chr_data[7] == 78) {
						me.tmp1 = 1;
					}
					else {
						me.tmp1 = -1;
					}
					print(me.chr_data[0]-65, "\n");
					print(me.tmp1*num(me.text),"\n");
					
					me.text = "";
					for(me.tmp1=8; me.tmp1 < 13; me.tmp1+=1) {
						if(me.chr_data[me.tmp1] != nil) {
							me.text = me.text~chr(me.chr_data[me.tmp1]);
						}
					}
					if(me.chr_data[13] == 69) {
						me.tmp1 = 1;
					}
					else {
						me.tmp1 = -1;
					}
					print(me.tmp1*num(me.text),"\n");
					me.setScratchpad(0);
				}
				else {
					if(num(character) == nil) {
						# wpt id
						me.tmp1 = 0;
						me.counter = 0;
						me.chr_data[me.tmp1] = character[0];
					}
					else {
						# wpt data
						me.tmp1 = me.counter+2;
						me.counter = me.counter+1;
						if(me.counter == 2 or me.counter == 8) me.counter = me.counter+1;
						if(me.counter == 6) {
							me.chr_data[me.tmp1] = 78;
						}
						else {
							me.chr_data[me.tmp1] = character[0];
						}
					}
					me.setTextBuffer();
				}
			}
		}
	},
	setText: func(text)
	{
		me.scratchpad.setText(text);
	},
	setTextBuffer: func {
		me.text = "";
		for(me.tmp1=0; me.tmp1 < 30; me.tmp1+=1) {
			if(me.chr_data[me.tmp1] != nil) {
				me.text = me.text~chr(me.chr_data[me.tmp1]);
			}
		}
		me.scratchpad.setText(me.text);
	},
	loadWPT: func(index) {
		me.wp = me.fp.currentWP();
		me.tmp1 = me.wp.lat;
		me.tmp2 = me.wp.lon;
		me.tmp3 = me.wp.index+65;
		me.counter = 0;
		me.text = sprintf("%s %.2f%s%.2f%s",
							chr(me.tmp3),
							abs(me.tmp1),
							(me.tmp1<0)?"S":"N",
							abs(me.tmp2),
							(me.tmp2<0)?"W":"E");

		for(me.tmp1=0; me.tmp1 < size(me.text); me.tmp1+=1) {
			me.chr_data[me.tmp1] = me.text[me.tmp1];
		}
		me.setText(me.text);
	},
	setScratchpad: func(input = 0) {
		me.text = "";

		if(input == 0) {
			me.scratchpad.setText("");
		}
		else if(input == 1) {
			# wpt
			me.loadWPT(0);
			me.mode = input;
		}
		else if(input == 2) {
			# wps
			me.setTextBuffer();
		}
	},
	update: func
	{
		me.time.setText(getprop("sim/time/local-time-string"));
	}
};
