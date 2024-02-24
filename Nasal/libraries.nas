#----------------------------------------------------------------------------
# Panavia Tornado System Libraries
#----------------------------------------------------------------------------
var SweepAngles=[25,33,45,58,63,67]; #25=fully forward
var Sweep=0;

#----------------------------------------------------------------------------
var doMagicStartup = func {
	setprop("fdm/jsbsim/electric/switches/battery", 1);
	setprop("controls/engines/engine[0]/starter", "true");
	setprop("controls/engines/engine[1]/starter", "true");
	setprop("fdm/jsbsim/electric/switches/ehdd", 1);
	setprop("fdm/jsbsim/electric/switches/crpmd", 1);
	setprop("fdm/jsbsim/electric/switches/tvtab1", 1);
	setprop("fdm/jsbsim/electric/switches/tvtab2", 1);
	settimer(func {
		setprop("controls/engines/engine[0]/cutoff", "false");
		setprop("controls/engines/engine[1]/cutoff", "false");
		setprop("fdm/jsbsim/electric/switches/dc-gen", 1);
		setprop("fdm/jsbsim/electric/switches/ac-gen", 1);
		setprop("instrumentation/hud/swMode", 2);
		setprop("fdm/jsbsim/electric/switches/landing-lights", 1);
	}, 5);
}

#----------------------------------------------------------------------------
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

#----------------------------------------------------------------------------
var CurrentView_Num = props.globals.getNode("sim/current-view/view-number");
var nav_view_num = view.indexof("Navigators View");

var toggle_cockpit_views = func() {
	if (CurrentView_Num.getValue() != 0 ) {
		CurrentView_Num.setValue(0);
	} else {
		CurrentView_Num.setValue(nav_view_num);
	}
}

#----------------------------------------------------------------------------
var indexTankLeft = 0;
var indexTankRight = 4;
var valueLeft = 0;
var valueRight = 0;
var needleLeft = props.globals.getNode("instrumentation/fuel/needleLeft");
var needleRight = props.globals.getNode("instrumentation/fuel/needleRight");
var btTEST = props.globals.getNode("instrumentation/fuel/btTEST");
var btCFUS = props.globals.getNode("instrumentation/fuel/btCFUS");
var btUFUS = props.globals.getNode("instrumentation/fuel/btUFUS");
var btWING = props.globals.getNode("instrumentation/fuel/btWING");
var btUWING = props.globals.getNode("instrumentation/fuel/btUWING");

var fuel_loop = func () {
	indexTankLeft = 9; # invalid tank
	indexTankRight = 9; # invalid tank
	
	if(getprop(("fdm/jsbsim/electric/buses/bus-dc") or 0) > 18) {
		indexTankLeft = 0;
		indexTankRight = 4;
		
		if(btTEST.getValue()) {
			# test successful if indicator shows 0
			indexTankLeft = 9; # invalid tank
			indexTankRight = 9; # invalid tank
		}
		if(btCFUS.getValue()) {
			indexTankLeft = 2;
			indexTankRight = 2;
		}
		if(btUFUS.getValue()) {
			indexTankLeft = 6;
			indexTankRight = 7;
		}
		if(btWING.getValue()) {
			indexTankLeft = 1;
			indexTankRight = 3;
		}
		if(btUWING.getValue()) {
			indexTankLeft = 5;
			indexTankRight = 8;
		}
	}
	valueLeft = 0.7*valueLeft + 0.3*(getprop("consumables/fuel/tank["~indexTankLeft~"]/level-kg") or 0);
	valueRight = 0.7*valueRight + 0.3*(getprop("consumables/fuel/tank["~indexTankRight~"]/level-kg") or 0);
	needleLeft.setValue(valueLeft);
	needleRight.setValue(valueRight);
}
var fuel_timer = maketimer(0.05, fuel_loop);
fuel_timer.start();
