var pow2 = func(x) { return x * x; };
var vec_length = func(x, y) { return math.sqrt(pow2(x) + pow2(y)); };
var round0 = func(x) { return math.abs(x) > 0.01 ? x : 0; };
var clamp = func(x, min, max) { return x < min ? min : (x > max ? max : x); }

var rad_alt = 0;
var rot = 0;
var vel_gx = 0;
var vel_gy = 0;
var vel_gz = 0;
var yaw = 0;
var roll = 0;
var pitch = 0;
var sy = 0; var cy = 0;
var sr = 0; var cr = 0;
var sp = 0; var cp = 0;
var vel_bx = 0;
var vel_by = 0;
var vel_bz = 0;
var dir_y = 0;
var dir_x = 0;
var speed_error = 0;
var acc = 0;

var hud_base = {
	new: func(canvasGroup, instance)
	{
		var m = { parents: [hud_base] };
		var font_mapper = func(family, weight)
		{
			return "Helvetica.txf";
		};
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/hud/hud_base.svg", {'font-mapper': font_mapper});
		
		var svg_keys = ["asi", "altitude", "needle",
				"aoaMkr", "aoaScale", "vsiMkr",
				"vv", "lock", "loc", "gs",
				"ladder", "heading", "hdgBug"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.aoaScale.hide();
		m.hdgBug.hide();
		m.h_trans = m.ladder.createTransform();
		m.h_rot   = m.ladder.createTransform();
		m.heading.set("clip", "rect(0, 169, 256, 69)"); #top,right,bottom,left
		m.tmp = 0;

		m.input = {
			alpha:    "orientation/alpha-deg",
			ias:      "velocities/airspeed-kt",
			alt:      "instrumentation/altimeter/indicated-altitude-ft",
			pitch:    "orientation/pitch-deg",
			roll:     "orientation/roll-deg",
			hdg:      "orientation/heading-deg",
			speed_n:  "velocities/speed-north-fps",
			speed_e:  "velocities/speed-east-fps",
			speed_d:  "velocities/speed-down-fps",
			vsi:      "velocities/vertical-speed-fps",
			loc:      "instrumentation/nav/in-range",
			gs:       "instrumentation/nav/gs-in-range",
			vv:       "instrumentation/hud/swVV"
		};
		foreach(var name; keys(m.input))
			m.input[name] = props.globals.getNode(m.input[name], 1);

		m.group = canvasGroup;
		return m;
	},
	update: func()
	{
		# asi
		me.asi.setText(sprintf("%d", me.input.ias.getValue()));

		# alt
		me.tmp = me.input.alt.getValue();
		me.altitude.setText(sprintf("%d", me.tmp));
		me.needle.setRotation(me.tmp*math.pi*0.002);

		# aoa
		me.tmp = me.input.alpha.getValue();
		if(me.tmp < 0) {
			me.tmp = 0;
		}
		if(me.tmp > 25) {
			me.tmp = 25;
		}
		#me.aoaScale.setScale(1, 0.5*me.tmp);
		#me.aoaScale.setTranslation(0, 90+0.25*me.tmp);
		me.aoaMkr.setTranslation(0, -3*me.tmp);

		# vsi
		me.tmp = me.input.vsi.getValue();
		if(me.tmp < -100) {
			me.tmp = -100;
		}
		if(me.tmp > 100) {
			me.tmp = 100;
		}
		me.vsiMkr.setTranslation(0, -0.3*me.tmp);

		# pitch
		me.h_trans.setTranslation(0, 20 * me.input.pitch.getValue());
		me.h_rot.setRotation(-me.input.roll.getValue() * math.pi / 180.0, 120, 128);

		# hdg
		me.tmp = me.input.hdg.getValue();
		if(me.tmp < 180)
			me.heading.setTranslation(-me.tmp*3.23,0);
		else
			me.heading.setTranslation((360-me.tmp)*3.23,0);

		# velocity vector
		if(me.input.vv.getValue()) {
			me.lock.hide();
			vel_gx = me.input.speed_n.getValue();
			vel_gy = me.input.speed_e.getValue();
			vel_gz = me.input.speed_d.getValue();
		
			yaw = me.input.hdg.getValue() * math.pi / 180.0;
			roll = me.input.roll.getValue() * math.pi / 180.0;
			pitch = me.input.pitch.getValue() * math.pi / 180.0;
		
			sy = math.sin(yaw); cy = math.cos(yaw);
			sr = math.sin(roll); cr = math.cos(roll);
			sp = math.sin(pitch); cp = math.cos(pitch);

			vel_bx = vel_gx * cy * cp
				+ vel_gy * sy * cp
				+ vel_gz * -sp;
			vel_by = vel_gx * (cy * sp * sr - sy * cr)
				+ vel_gy * (sy * sp * sr + cy * cr)
				+ vel_gz * cp * sr;
			vel_bz = vel_gx * (cy * sp * cr + sy * sr)
				+ vel_gy * (sy * sp * cr - cy * sr)
				+ vel_gz * cp * cr;
	
			dir_y = math.atan2(round0(vel_bz), math.max(vel_bx, 0.01)) * 180.0 / math.pi;
			dir_x  = math.atan2(round0(vel_by), math.max(vel_bx, 0.01)) * 180.0 / math.pi;

			me.vv.setTranslation(dir_x * 18, dir_y * 18);
		}
		else {
			me.lock.show();
			me.vv.setTranslation(0, 0);
		}
		if(me.input.loc.getValue()) {
			me.loc.show();
		}
		else {
			me.loc.hide();
		}
		if(me.input.gs.getValue()) {
			me.gs.show();
		}
		else {
			me.gs.hide();
		}
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
