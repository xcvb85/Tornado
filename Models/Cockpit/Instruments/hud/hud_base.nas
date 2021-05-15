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
		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Models/Cockpit/Instruments/hud/hud_base.svg", {'font-mapper': font_mapper});
		
		var svg_keys = ["altitude", "asi", "heading", "ladder", "vv"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
		}
		m.h_trans = m.ladder.createTransform();
		m.h_rot   = m.ladder.createTransform();
		m.heading.set("clip", "rect(0, 169, 256, 69)"); #top,right,bottom,left

		m.input = {
			pitch:    "orientation/pitch-deg",
			roll:     "orientation/roll-deg",
			hdg:      "orientation/heading-deg",
			speed_n:  "velocities/speed-north-fps",
			speed_e:  "velocities/speed-east-fps",
			speed_d:  "velocities/speed-down-fps",
		};
		foreach(var name; keys(m.input))
			m.input[name] = props.globals.getNode(m.input[name], 1);

		m.group = canvasGroup;
		return m;
	},
	update: func()
	{
		me.h_trans.setTranslation(0, 20 * me.input.pitch.getValue());
		me.h_rot.setRotation(-me.input.roll.getValue() * math.pi / 180.0, 120, 128);

		# flight path vector (FPV)
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
