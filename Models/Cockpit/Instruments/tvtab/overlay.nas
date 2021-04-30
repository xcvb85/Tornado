var canvas_overlay = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_overlay], chr_data:[], fp:{}, wp:{} };
		m.fp = flightplan();
		m.text = "";
		m.prefix = "";
		m.mode = 0; # 0=disabled, 1=coordinates
		m.type = 0; # 1=wpt, 2=grid
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
				# Coordinates
				if(character == "\n") {
					# enter
					me.text = "";
					me.counter = 0;
					
					for(me.tmp1=0; me.tmp1 < 6; me.tmp1+=1) {
						if(me.chr_data[me.tmp1] != nil) {
							me.text = me.text~chr(me.chr_data[me.tmp1]);
						}
					}
					if(me.chr_data[7] == 78) {
						# N
						me.tmp1 = 1;
					}
					else {
						me.tmp1 = -1;
					}
					print(me.prefix[0]-65, "\n");
					print(me.tmp1*num(me.text),"\n");
					
					me.text = "";
					for(me.tmp1=8; me.tmp1 < 13; me.tmp1+=1) {
						if(me.chr_data[me.tmp1] != nil) {
							me.text = me.text~chr(me.chr_data[me.tmp1]);
						}
					}
					if(me.chr_data[13] == 69) {
						# E
						me.tmp1 = 1;
					}
					else {
						me.tmp1 = -1;
					}
					print(me.tmp1*num(me.text),"\n");
					me.setScratchpad(0);
				}
				else {
					if(num(character) != nil) {
						# number
						if(me.counter < 14) {
							if(me.counter == 3 or me.counter == 10) {
								# skip point
								me.counter = me.counter+1;
							}
							if(me.counter == 6) {
								if(character[0] == 53) {
									# 5
									me.chr_data[me.counter] = 78; # N
									me.counter = me.counter+1;
								}
								else if(character[0] == 54) {
									me.chr_data[me.counter] = 83; # S
									me.counter = me.counter+1;
								}
							}
							else if(me.counter == 12) {
								if(character[0] == 48) {
									me.chr_data[me.counter] = 69; # E
									me.counter = me.counter+1;
								}
								else if(character[0] == 48) {
									me.chr_data[me.counter] = 87; # W
									me.counter = me.counter+1;
								}
							}
							else {
								if((me.counter != 0 and me.counter != 7) or character[0] < 50) {
									me.chr_data[me.counter] = character[0];
									me.counter = me.counter+1;
								}
							}
							me.setTextBuffer();
						}
					}
					else {
						# character
						me.tmp1 = 0;
						me.counter = 0;
						me.prefix = character;
						me.loadWPT(character[0]-65);
					}
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
		me.scratchpad.setText(me.prefix~" "~me.text);
	},
	loadCoordinates: func(prefix, lat, lon) {
		me.prefix = prefix;
		me.counter = 0;
		setprop("instrumentation/tvtab1/lon", lon);
		setprop("instrumentation/tvtab1/lat", lat);
		me.text = sprintf("%06.2f%s%06.2f%s",
							abs(lat),
							(me.tmp1<0)?"S":"N",
							abs(lon),
							(me.tmp2<0)?"W":"E");

		for(me.tmp1=0; me.tmp1 < size(me.text); me.tmp1+=1) {
			me.chr_data[me.tmp1] = me.text[me.tmp1];
		}
		me.setTextBuffer();
	},
	loadWPT: func(index=-1) {
		if(index < 0) {
			me.wp = me.fp.currentWP();
		}
		else {
			me.wp = me.fp.getWP(index);
		}
		me.loadCoordinates(chr(me.wp.index+65), me.wp.lat, me.wp.lon);
	},
	loadGRD: func {
		me.loadCoordinates("GRD", me.wp.lat, me.wp.lon);
	},
	setScratchpad: func(input = 0) {
		me.text = "";

		if(input == 0) {
			me.scratchpad.setText("");
			setprop("instrumentation/tvtab1/lon", 0);
			setprop("instrumentation/tvtab1/lat", 0);
		}
		else if(input == 1) {
			# wpt
			me.loadWPT(-1);
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
