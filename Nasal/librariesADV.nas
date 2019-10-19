# Panavia Tornado System Libraries
aircraft.livery.init("Aircraft/Tornado/Models/liveriesADV/");
var Tmp=0;

var doMagicStartup = func {
	setprop("/controls/engines/engine[0]/starter", "true");
	setprop("/controls/engines/engine[1]/starter", "true");
	settimer(func {
		setprop("/controls/engines/engine[0]/cutoff", "false");
		setprop("/controls/engines/engine[1]/cutoff", "false");
	}, 10);
}

var aglgears = func {
	var agl = getprop("/position/altitude-agl-ft") or 0;
	var aglft = agl - 1.86;  # is the position from the Tornado above ground
	var aglm = aglft * 0.3048;
	setprop("/position/gear-agl-ft", aglft);
	setprop("/position/gear-agl-m", aglm);

	settimer(aglgears, 0.01);
}
#aglgears();

var wingSweep = func(direction) {
	Tmp = getprop("fdm/jsbsim/fcs/wing-sweep-cmd") + direction;
	if(Tmp > 2) {
		Tmp = 2;
	}
	if(Tmp < 0) {
		Tmp = 0;
	}
	setprop("fdm/jsbsim/fcs/wing-sweep-cmd", Tmp);
}
