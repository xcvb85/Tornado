var ARM_SIM = -1;
var ARM_OFF = 0;# these 3 are needed by fire-control.
var ARM_ARM = 1;

print("** Pylon & fire control system started. **");

var variant = getprop("/sim/variant-id");
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

var cannon = stations.SubModelWeapon.new("27mm Cannon", 0.254, 510, [5], [4], props.globals.getNode("fdm/jsbsim/fcs/guntrigger",1), 0, func{return 1;}, 0);
cannon.typeShort = "GUN";
cannon.brevity = "Guns guns";

var fuelTankWL = stations.FuelTank.new("Left 1200l Wing-Tank", "TK1200", 5, 317, "tornado/tankWL1200");
var fuelTankCL = stations.FuelTank.new("Left 1200l Center-Tank", "TK1200", 6, 317, "tornado/tankCL1200");
var fuelTankCR = stations.FuelTank.new("Right 1200l Center-Tank", "TK1200", 7, 317, "tornado/tankCR1200");
var fuelTankWR = stations.FuelTank.new("Right 1200l Wing-Tank", "TK1200", 8, 317, "tornado/tankWR1200");

fuelTankWL.del();
fuelTankCL.del();
fuelTankCR.del();
fuelTankWR.del();

var pylonSets = {
    empty: {name: "Empty", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    fuel12WL: {name: fuelTankWL.type, content: [fuelTankWL], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fuel12CL: {name: fuelTankCL.type, content: [fuelTankCL], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fuel12CR: {name: fuelTankCR.type, content: [fuelTankCR], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},
    fuel12WR: {name: fuelTankWR.type, content: [fuelTankWR], fireOrder: [0], launcherDragArea: 0.35, launcherMass: 531, launcherJettisonable: 1, showLongTypeInsteadOfCount: 1, category: 2},

    mm27:  {name: "27mm Cannon", content: [cannon], fireOrder: [0], launcherDragArea: 0.0, launcherMass: 0, launcherJettisonable: 0, showLongTypeInsteadOfCount: 1, category: 1},
    boz10x: {name: "BOZ-101/102/107", content: [], fireOrder: [], launcherDragArea: 0.0, launcherMass: 100, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},

    # A/A weapons
    aim9l:     {name: "1 x AIM-9L", content: ["AIM-9L"], fireOrder: [0], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip
    aim9l_2:   {name: "2 x AIM-9L", content: ["AIM-9L","AIM-9L"], fireOrder: [0,1], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip
    aim120_2:  {name: "2 x AIM-120", content: ["AIM-120","AIM-120"], fireOrder: [0,1], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip
    rb71_2:    {name: "2 x Skyflash", content: ["RB-71","RB-71"], fireOrder: [0,1], launcherDragArea: 0.025, launcherMass: 90, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 1},#non wingtip

    # A/G weapons
    a88:       {name: "1 x AGM-88", content: ["AGM-88"], fireOrder: [0], launcherDragArea: 0.06, launcherMass: 340, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    m82_2:     {name: "2 x MK-82", content: ["MK-82","MK-82"], fireOrder: [0,1], launcherDragArea: 0.05, launcherMass: 220, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    m82air_2:  {name: "2 x MK-82AIR", content: ["MK-82AIR","MK-82AIR"], fireOrder: [0,1], launcherDragArea: 0.05, launcherMass: 220, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    m83:       {name: "1 x MK-83", content: ["MK-83"], fireOrder: [0], launcherDragArea: 0.075, launcherMass: 470, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    m84:       {name: "1 x MK-84", content: ["MK-84"], fireOrder: [0], launcherDragArea: 0.05, launcherMass: 220, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3},
    b617:      {name: "1 x B61-7", content: ["B61-7"], fireOrder: [0], launcherDragArea: 0.05, launcherMass:220, launcherJettisonable: 0, showLongTypeInsteadOfCount: 0, category: 3}
};

var pylon1set = nil;
var pylon2set = nil;
var pylon3set = nil;
var pylon4set = nil;
var pylon5set = nil;
var pylon6set = nil;
var pylon7set = nil;
var pylon8set = nil;
var pylon9set = nil;

if(variant==1) {
    # IDS
    pylon1set = [pylonSets.empty, pylonSets.boz10x];
    pylon2set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    pylon3set = [pylonSets.empty, pylonSets.fuel12WL];
    pylon4set = [pylonSets.empty, pylonSets.m82_2, pylonSets.m82air_2, pylonSets.m83, pylonSets.m84]; #pylonSets.fuel12CL
    pylon5set = [pylonSets.empty, pylonSets.b617];
    pylon6set = [pylonSets.empty, pylonSets.m82_2, pylonSets.m82air_2, pylonSets.m83, pylonSets.m84]; #pylonSets.fuel12CR
    pylon7set = [pylonSets.empty, pylonSets.fuel12WR];
    pylon8set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    pylon9set = [pylonSets.empty, pylonSets.boz10x];
}
else if(variant==2) {
    # ADV
    pylon1set = [pylonSets.empty, pylonSets.boz10x];
    pylon2set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    pylon3set = [pylonSets.empty, pylonSets.fuel12WL];
    pylon4set = [pylonSets.empty, pylonSets.rb71_2, pylonSets.aim120_2];
    pylon5set = [pylonSets.empty];
    pylon6set = [pylonSets.empty, pylonSets.rb71_2, pylonSets.aim120_2];
    pylon7set = [pylonSets.empty, pylonSets.fuel12WR];
    pylon8set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    pylon9set = [pylonSets.empty, pylonSets.boz10x];
}
else {
    # ECR
    pylon1set = [pylonSets.empty, pylonSets.boz10x];
    pylon2set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    pylon3set = [pylonSets.empty, pylonSets.a88];
    pylon4set = [pylonSets.empty, pylonSets.a88];
    pylon5set = [pylonSets.empty];
    pylon6set = [pylonSets.empty, pylonSets.a88];
    pylon7set = [pylonSets.empty, pylonSets.a88];
    pylon8set = [pylonSets.empty, pylonSets.aim9l, pylonSets.aim9l_2];
    pylon9set = [pylonSets.empty, pylonSets.boz10x];
}

setprop("payload/armament/fire-control/serviceable", 1);
pylon1 = stations.Pylon.new("Left wing outboard pylon",  0, [4.510, -4.511, -0.100], pylon1set,  0, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[0]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[0]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon2 = stations.Pylon.new("Left wing inboard pylon AIM-9",   1, [4.510, -4.511, -0.100], pylon2set,  1, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon3 = stations.Pylon.new("Left wing inboard pylon",   2, [4.510, -4.511, -0.100], pylon3set,  2, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[1]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[1]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon4 = stations.Pylon.new("Left Fuselage",             3, [3.575, -3.309,  0.025], pylon4set,  3, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[2]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[2]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon5 = stations.Pylon.new("Center Station",            4, [2.800,  0.000, -0.700], pylon5set,  4, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[3]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[3]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon6 = stations.Pylon.new("Right Fuselage",            5, [3.575,  3.309,  0.025], pylon6set,  5, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[4]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[4]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon7 = stations.Pylon.new("Right wing inboard pylon",  6, [4.510,  4.511, -0.100], pylon7set,  6, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[5]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon8 = stations.Pylon.new("Right wing inboard pylon AIM-9",  7, [4.510,  4.511, -0.100], pylon8set,  7, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[5]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[5]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylon9 = stations.Pylon.new("Right wing outboard pylon", 8, [4.510,  4.511, -0.100], pylon9set,  8, props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[6]",1),props.globals.getNode("fdm/jsbsim/inertia/pointmass-dragarea-sqft[6]",1),func{return getprop("payload/armament/fire-control/serviceable") and 1;},func{return 1;});
pylonI = stations.InternalStation.new("Internal gun mount",   9, [pylonSets.mm27], props.globals.getNode("fdm/jsbsim/inertia/pointmass-weight-lbs[10]", 1));

pylons = [pylon1, pylon2, pylon3, pylon4, pylon5, pylon6, pylon7, pylon8, pylon9, pylonI];
fcs = fc.FireControl.new(pylons, [9, 7, 1, 6, 2, 5, 3, 4], ["27mm Cannon", "AIM-9L", "MK-82", "MK-82AIR", "MK-83", "MK-84", "B61-7", "AIM-120", "RB-71", "AGM-88"]);

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
        setprop("ai/submodels/submodel[4]/count", 260);
        setprop("ai/submodels/submodel[5]/count", 260);
        setprop("ai/submodels/submodel[6]/count", 260);
        setprop("ai/submodels/submodel[7]/count", 260);
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var refill_cf = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
        # chaffs/flares
        setprop("ai/submodels/submodel[0]/count", 40);
        setprop("ai/submodels/submodel[1]/count", 40);
        setprop("ai/submodels/submodel[2]/count", 40);
        setprop("ai/submodels/submodel[3]/count", 40);
        screen.log.write(msgB, 0.5, 0.5, 1);
    }
    else {
        screen.log.write(msgA, 0.5, 0.5, 1);
    }
}

var refill_weapons = func {
    if(!getprop("payload/armament/msg") or getprop("gear/gear[0]/wow")) {
    
        if(variant==1) {
            # IDS
            pylon1.loadSet(pylonSets.boz10x);
            pylon2.loadSet(pylonSets.aim9l);
            pylon3.loadSet(pylonSets.fuel12WL);
            pylon4.loadSet(pylonSets.m82air_2);
            pylon5.loadSet(pylonSets.empty);
            pylon6.loadSet(pylonSets.m82air_2);
            pylon7.loadSet(pylonSets.fuel12WR);
            pylon8.loadSet(pylonSets.aim9l);
            pylon9.loadSet(pylonSets.boz10x);
        }
        else if(variant==2) {
            # ADV
            pylon1.loadSet(pylonSets.boz10x);
            pylon2.loadSet(pylonSets.aim9l);
            pylon3.loadSet(pylonSets.empty);
            pylon4.loadSet(pylonSets.aim120_2);
            pylon5.loadSet(pylonSets.empty);
            pylon6.loadSet(pylonSets.aim120_2);
            pylon7.loadSet(pylonSets.empty);
            pylon8.loadSet(pylonSets.aim9l);
            pylon9.loadSet(pylonSets.boz10x);
        } else {
            # ECR
            pylon1.loadSet(pylonSets.boz10x);
            pylon2.loadSet(pylonSets.aim9l);
            pylon3.loadSet(pylonSets.a88);
            pylon4.loadSet(pylonSets.a88);
            pylon5.loadSet(pylonSets.empty);
            pylon6.loadSet(pylonSets.a88);
            pylon7.loadSet(pylonSets.a88);
            pylon8.loadSet(pylonSets.aim9l);
            pylon9.loadSet(pylonSets.boz10x);
        }
    } else {
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
