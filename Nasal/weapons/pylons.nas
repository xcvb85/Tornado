var ARM_SIM = -1;
var ARM_OFF = 0;# these 3 are needed by fire-control.
var ARM_ARM = 1;

print("** Pylon & fire control system started. **");

var variant = 2; #getprop("/sim/variant-id");
var pylon1 = nil; #left outboard
var pylon2 = nil; #left inboard aim9
var pylon3 = nil; #left inboard
var pylon4 = nil; #left fuselage
var pylon5 = nil; #fuselage
var pylon6 = nil; #right fuselage
var pylon7 = nil; #right inboard
var pylon8 = nil; #right inboard aim9
var pylon9 = nil; #right outboard
var pylonI = nil; #gun

var msgA = "Please return to base.";
var msgB = "Refill complete.";

var cannon = stations.SubModelWeapon.new("27mm Cannon", 0.254, 150, [0,1], [], props.globals.getNode("controls/armament/trigger-gun",1), 0, nil,0);
cannon.typeShort = "GUN";
cannon.brevity = "Guns guns";

var fuelTank1 = stations.FuelTank.new("Droptank", "droptank", 4, 200, "sim/model/Tornado/stores");
var fuelTank2 = stations.FuelTank.new("Droptank", "droptank", 3, 200, "sim/model/Tornado/stores");
var fuelTank3 = stations.FuelTank.new("Droptank", "droptank", 5, 200, "sim/model/Tornado/stores");

var pylonSets = {
    empty: {name: "Empty", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    fueltank1: {name: "Droptank", content: [fuelTank1], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fueltank2: {name: "Droptank", content: [fuelTank2], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fueltank3: {name: "Droptank", content: [fuelTank3], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    mm27:  {name: "27mm Cannon", content: [cannon], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},
    boz107: {name: "BOZ-107 CFD", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 480, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    # A/A weapons
    aim9l:     {name: "1 x AIM-9L", content: ["AIM-9L"], fireOrder: [0], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip
    aim9l_2:   {name: "2 x AIM-9L", content: ["AIM-9L","AIM-9L"], fireOrder: [0,1], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip
    aim120_2:  {name: "2 x AIM-120", content: ["AIM-120","AIM-120"], fireOrder: [0,1], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip
    rb71_2:    {name: "2 x Skyflash", content: ["RB-71","RB-71"], fireOrder: [0,1], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip

    # A/G weapons
    m82_2:     {name: "2 x MK-82", content: ["MK-82","MK-82"], fireOrder: [0], launcherDragArea: 0.05, launcherMass: 220, launcherJettisonable: 1, showLongTypeInsteadOfCount: 0, category: 3},
    m82air_2:  {name: "2 x MK-82AIR", content: ["MK-82AIR","MK-82AIR"], fireOrder: [0,1], launcherDragArea: 0.075, launcherMass: 313, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    m83:       {name: "1 x MK-83", content: ["MK-83"], fireOrder: [0], launcherDragArea: 0.075, launcherMass: 470, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    m84:       {name: "1 x MK-84", content: ["MK-84"], fireOrder: [0], launcherDragArea: 0.05, launcherMass: 220, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    a88:       {name: "1 x AGM-88", content: ["AGM-88"], fireOrder: [0], launcherDragArea: 0.06, launcherMass: 340, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
};

if(variant==1) {
    # IDS
    var pylon1set = [pylonSets.empty, pylonSets.boz107];
    var pylon2set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    var pylon3set = [pylonSets.empty, pylonSets.fueltank1];
    var pylon4set = [pylonSets.empty, pylonSets.m82_2, pylonSets.m82air_2, pylonSets.m83, pylonSets.m84];
    var pylon5set = [pylonSets.empty, pylonSets.fueltank2];
    var pylon6set = [pylonSets.empty, pylonSets.m82_2, pylonSets.m82air_2, pylonSets.m83, pylonSets.m84];
    var pylon7set = [pylonSets.empty, pylonSets.fueltank3];
    var pylon8set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    var pylon9set = [pylonSets.empty, pylonSets.boz107];
}
else if(variant==2) {
    # ADV
    var pylon1set = [pylonSets.empty, pylonSets.boz107];
    var pylon2set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    var pylon3set = [pylonSets.empty, pylonSets.fueltank1];
    var pylon4set = [pylonSets.empty, pylonSets.rb71_2, pylonSets.aim120_2];
    var pylon5set = [pylonSets.empty, pylonSets.fueltank2];
    var pylon6set = [pylonSets.empty, pylonSets.rb71_2, pylonSets.aim120_2];
    var pylon7set = [pylonSets.empty, pylonSets.fueltank3];
    var pylon8set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    var pylon9set = [pylonSets.empty, pylonSets.boz107];
}
else {
    # ECR
    var pylon1set = [pylonSets.empty, pylonSets.boz107];
    var pylon2set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    var pylon3set = [pylonSets.empty, pylonSets.fueltank1, pylonSets.a88];
    var pylon4set = [pylonSets.empty, pylonSets.a88];
    var pylon5set = [pylonSets.empty, pylonSets.fueltank2];
    var pylon6set = [pylonSets.empty, pylonSets.a88];
    var pylon7set = [pylonSets.empty, pylonSets.fueltank1, pylonSets.a88];
    var pylon8set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    var pylon9set = [pylonSets.empty, pylonSets.boz107];
}

setprop("payload/armament/fire-control/serviceable", 1);
pylon1 = stations.Pylon.new("Left wing outboard pylon",  0, [4.510, -4.511, -0.100], pylon1set,  0, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[0]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[0]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon2 = stations.Pylon.new("Left wing inboard pylon AIM-9",   1, [4.510, -4.511, -0.100], pylon2set,  1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon3 = stations.Pylon.new("Left wing inboard pylon",   2, [4.510, -4.511, -0.100], pylon2set,  1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon4 = stations.Pylon.new("Left Fuselage",             3, [3.575, -3.309,  0.025], pylon3set,  2, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[2]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon5 = stations.Pylon.new("Center Station",            4, [2.800,  0.000, -0.700], pylon4set,  3, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[3]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon6 = stations.Pylon.new("Right Fuselage",            5, [3.575,  3.309,  0.025], pylon5set,  4, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon7 = stations.Pylon.new("Right wing inboard pylon",  6, [4.510,  4.511, -0.100], pylon6set,  5, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[5]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon8 = stations.Pylon.new("Right wing inboard pylon AIM-9",  7, [4.510,  4.511, -0.100], pylon6set,  5, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[5]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon9 = stations.Pylon.new("Right wing outboard pylon", 8, [4.510,  4.511, -0.100], pylon7set,  6, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[6]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[6]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylonI = stations.InternalStation.new("Internal gun mount",   9, [pylonSets.mm27], props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[10]", 1));

pylons = [pylon1, pylon2, pylon3, pylon4, pylon5, pylon6, pylon7, pylon8, pylon9, pylonI];
fcs = fc.FireControl.new(pylons, [7, 1, 6, 2, 5, 3, 4], ["27mm Cannon", "AIM-9L"]);

var selectedWeapon = {};
var bore_loop = func {
    #enables firing of aim9 without radar. The aim-9 seeker will be fixed 3.5 degs below bore and any aircraft the gets near that will result in lock.
    if (fcs != nil) {
        selectedWeapon = fcs.getSelectedWeapon();
        if (selectedWeapon != nil and (selectedWeapon.type == "AIM-9L")) {
            selectedWeapon.setContacts(radar_system.getCompleteList());
            selectedWeapon.commandDir(0,-3.5);# the real is bored to -6 deg below real bore
        }
    }
    settimer(bore_loop, 0.5);
};
if (fcs!=nil) {
    bore_loop();
}

var refill_cannons = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        # cannons
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var refill_cf = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        # chaffs/flares
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var empty = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon1.loadSet(pylonSets.empty);
        pylon2.loadSet(pylonSets.empty);
        pylon3.loadSet(pylonSets.empty);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.empty);
        pylon7.loadSet(pylonSets.empty);
        pylon8.loadSet(pylonSets.empty);
        pylon9.loadSet(pylonSets.empty);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var aa_mk82 = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        pylon1.loadSet(pylonSets.boz107);
        pylon2.loadSet(pylonSets.aim9l);
        pylon3.loadSet(pylonSets.fuelTank1);
        pylon4.loadSet(pylonSets.mk82_2);
        pylon5.loadSet(pylonSets.empty);
        pylon6.loadSet(pylonSets.mk82_2);
        pylon7.loadSet(pylonSets.fuelTank1);
        pylon8.loadSet(pylonSets.aim9l);
        pylon9.loadSet(pylonSets.boz107);
    } else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}
