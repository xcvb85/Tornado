# Panavia Tornado System Libraries
var SweepAngles=[25,33,45,58,63,67]; #25=fully forward
var Sweep=0;

var doMagicStartup = func {
	setprop("systems/electrical/Battery/Connected",1);
	setprop("controls/engines/engine[0]/starter", "true");
	setprop("controls/engines/engine[1]/starter", "true");
	setprop("instrumentation/ehdd/Connected", "1");
	setprop("instrumentation/tvtab1/Connected", "1");
	setprop("instrumentation/tvtab2/Connected", "1");
	settimer(func {
		setprop("controls/engines/engine[0]/cutoff", "false");
		setprop("controls/engines/engine[1]/cutoff", "false");
		setprop("systems/electrical/Generator1/Connected", 1);
		setprop("systems/electrical/Generator2/Connected", 1);
		setprop("instrumentation/hud/swMode", 1);
	}, 5);
}

var aglgears = func {
	var agl = getprop("/position/altitude-agl-ft") or 0;
	var aglft = agl - 1.86;  # is the position from the Tornado above ground
	var aglm = aglft * 0.3048;
	setprop("position/gear-agl-ft", aglft);
	setprop("position/gear-agl-m", aglm);

	settimer(aglgears, 0.01);
}
#aglgears();

var wingSweep = func(direction) {
	Sweep += direction;

	if(Sweep > 5) {
		Sweep = 5;
	}
	if(Sweep < 0) {
		Sweep = 0;
	}
	setprop("fdm/jsbsim/fcs/wing-sweep-cmd", (SweepAngles[Sweep]-25)/42.0);
}

togglereverser = func {
	r1 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[0]");
	r2 = props.globals.getNode("/fdm/jsbsim/propulsion/engine[1]");
	r3 = props.globals.getNode("/controls/engines/engine[0]");
	r4 = props.globals.getNode("/controls/engines/engine[1]");
	r5 = props.globals.getNode("/sim/input/selected");
	rv1 = props.globals.getNode("/engines/engine[0]/reverser-pos-norm");
	rv2 = props.globals.getNode("/engines/engine[1]/reverser-pos-norm");

	val = rv1.getValue();
	if (val == 0 or val == nil) {
		interpolate(rv1.getPath(), 1.0, 1.4);
		interpolate(rv2.getPath(), 1.0, 1.4);
		r1.getChild("reverser-angle-rad").setValue(math.pi);
		r2.getChild("reverser-angle-rad").setValue(math.pi);
		r3.getChild("reverser").setBoolValue(1);
		r4.getChild("reverser").setBoolValue(1);
	} else {
		if (val == 1.0) {
			interpolate(rv1.getPath(), 0.0, 1.4);
			interpolate(rv2.getPath(), 0.0, 1.4);
			r1.getChild("reverser-angle-rad").setValue(0);
			r2.getChild("reverser-angle-rad").setValue(0);
			r3.getChild("reverser").setBoolValue(0);
			r4.getChild("reverser").setBoolValue(0);
		}
	}
}
