# A LOT of the code here is from the Mirage 2000 and JA-37 Viggen. If you haven't already, definitely go and check those out, and show some love for the great work being put in over there!
# Also a massive thanks to Leto and the rest of the radar-mafia team for the great work on the radarSystem Framework, which forms the basis for the radar.

var DISPLAY_WIDTH = 310;
var DISPLAY_HEIGHT = 250;
var RDR_DISPLAY_WIDTH = 280;
var RDR_DISPLAY_HEIGHT = 224;
var TARGET_WIDTH = 7;
var TARGET_HEIGHT = 12;
var MAX_TARGETS = 9;

var canvas_rdr = {
	new: func(canvasGroup)
	{
		var m = { parents: [canvas_rdr, canvas_base.new(canvasGroup)] };

		var font_mapper = func(family, weight)
		{
			if(family == "'Liberation Sans'" and weight == "normal") {
				return "Helvetica.txf";
			}
		};

		canvas.parsesvg(canvasGroup, "Aircraft/Tornado/Nasal/tvtab/rdr.svg", {'font-mapper': font_mapper});


		var svg_keys = ["horizonBar", "acSpeed", "acHeading", "acAltitude", "radarMode", "cursor", "scan_line_horiz", "target_0","target_1", "target_2", "target_3", "target_4", "target_5", "target_6", "target_7", "target_8", "target_9", "target_10", "selected_target"];
		foreach(var key; svg_keys) {
			m[key] = canvasGroup.getElementById(key);
			print(key);
		}

		m.unknown_targets = setsize([],MAX_TARGETS);
		for (var i = 0; i < MAX_TARGETS; i += 1){
	        var name = "target_"~i;
	        var tgt_unk = canvasGroup.getElementById(name);
	        if (tgt_unk != nil){
	            m.unknown_targets[i] = tgt_unk;
	            tgt_unk.setTranslation(RDR_DISPLAY_WIDTH/2,RDR_DISPLAY_HEIGHT/2);
	            tgt_unk.setVisible(0);
	        }
	    }

		m.input = {
			ias:    "velocities/airspeed-kt",
			cursor_dx:        "controls/displays/cursor-total-slew-x",
			cursor_dy:        "controls/displays/cursor-total-slew-y",
			cursor_clicked:   "controls/displays/cursor-click",
			heading_true: 	  "/orientation/heading-deg"
		};
		foreach(var name; keys(m.input))
			m.input[name] = props.globals.getNode(m.input[name], 1);

		m.cursor_pos = [RDR_DISPLAY_WIDTH/8,-RDR_DISPLAY_HEIGHT*3/8];
		m.cursor_trigger_prev = 0;
		m.n_contacts = 10;
		m["acAltitude"].enableUpdate();
		# m["acHdg"].enableUpdate();
		# m["acSpeed"].enableUpdate();
		# m["radarMode"].enableUpdate();
		m.acHeading.enableUpdate();
		# m.acSpeed.enableUpdate();
		# m.radarMode.enableUpdate();
		m.cursor.setTranslation(RDR_DISPLAY_WIDTH/2,RDR_DISPLAY_HEIGHT/2);

		m.timer = maketimer(0.05, m, m.update);
		m.timer.start();
		return m;
	},
	getCursorDelta: func {
		return [me.input.cursor_dx.getValue(), me.input.cursor_dy.getValue(), me.input.cursor_clicked.getValue()];
	},
	resetCursorDelta: func {
		me.input.cursor_dx.setValue(0);
		me.input.cursor_dy.setValue(0);
		me.input.cursor_clicked.setValue(0);
	},
	_updateCursor: func(max_azimuth_rad, max_distance_m, radar_mode_name) {
		# Originally copied from JA37
		if (radar_mode_name == "TWS") {
			me.cursor.hide();
			return;
		}

		# Retrieve cursor movement from JSBSim, From Mirage (Adapted from Viggen)
		var cursor_mov = me.getCursorDelta();
		# me.resetCursorDelta();
		var click = cursor_mov[2] and !me.cursor_trigger_prev;
		me.cursor_trigger_prev = cursor_mov[2];

		me.cursor_pos[0] += cursor_mov[0] * RDR_DISPLAY_WIDTH * 0.025;
		me.cursor_pos[1] += cursor_mov[1] * RDR_DISPLAY_HEIGHT * 0.025;
		me.cursor_pos[0] = math.clamp(me.cursor_pos[0], -RDR_DISPLAY_WIDTH/2, RDR_DISPLAY_WIDTH/2);
		me.cursor_pos[1] = math.clamp(me.cursor_pos[1], -RDR_DISPLAY_HEIGHT/2, RDR_DISPLAY_HEIGHT/2);

		me.cursor.show();
		me.cursor.setTranslation(me.cursor_pos[0], me.cursor_pos[1]);
		# print(me.cursor_pos[0]);
		# print(me.cursor_pos[1]);

		if (click) {
			print("clicked");
			var new_sel = me._findCursorTrack();
			if (new_sel != nil) {
				print("... and designate");
				radar_system.apg68Radar.designate(new_sel);
			} else {
				print("... and undesignate");
				radar_system.apg68Radar.undesignate();
			}
			var radar_mode_root_name = radar_system.apg68Radar.currentMode.rootName;
			var radar_mode_name = radar_system.apg68Radar.getMode();
			print('Root '~radar_mode_root_name~' - mode '~radar_mode_name);
		}

		# # update the numbers
		# me.alimits = radar_system.apg68Radar.getCursorAltitudeLimits();
		# if (me.alimits != nil and radar_system.apg68Radar.currentMode.detectAIR == TRUE) {
		# 	me.cursor_upper_limit.setText(sprintf("%d", math.round(me.alimits[0]*0.001)));
		# 	me.cursor_lower_limit.setText(sprintf("%d", math.round(me.alimits[1]*0.001)));
		# } else {
		# 	me.cursor_upper_limit.setText("");
		# 	me.cursor_lower_limit.setText("");
		# }

		# var screen_pos = nil;
		# if (me.is_ppi == TRUE) {
		# 	screen_pos = _calcScreenPositionPPIScopeFromXY(me.cursor_pos[0], me.cursor_pos[1], max_distance_m);
		# } else {
		# 	screen_pos = _calcScreenPositionBScopeFromXY(me.cursor_pos[0], me.cursor_pos[1], max_distance_m, max_azimuth_rad);
		# }
		# me.cursor_distance.setText(sprintf("%d", math.round(screen_pos[1] * M2NM)));
		# me.cursor_dist_text.setText(sprintf("%d", math.round(screen_pos[1] * M2NM)));
		# me.cursor_hdg_text.setText(sprintf("%d", math.round(geo.normdeg(screen_pos[0] * R2D + me.heading_displayed))));
	},

	_updateTargets: func(max_azimuth_rad, max_distance_m, radar_mode_root_name) {
		var target_contacts_list = radar_system.apg68Radar.getActiveBleps();
		var i = 0;
		var has_priority = 0;
		var has_sniped_target = 0;
		var sniped_target_is_priority = 0;
		var relative_heading_rad = 0; # the heading of the target as seen by this aircraft with nose = North
		var screen_pos = nil;
		var target_speed_m_s = 0;

		me.radar_contacts = [];
		me.radar_contacts_pos = [];
		# me.targets_speed_group.removeAllChildren();
		var delta = nil;

		var screen_pos = nil;
		var info = nil;
		# walk through all existing targets as per available list
		foreach(var contact; target_contacts_list) {
			info = contact.getLastBlep();
			# print("DEBUG: contact.getHeading()=", contact.getHeading());
			relative_heading_rad = geo.normdeg(contact.getHeading() - me.input.heading_true.getValue()) * D2R;
			screen_pos = _calcScreenPositionBScopeToXY(info.getRangeNow(), max_distance_m, info.getAZDeviation()*D2R, max_azimuth_rad);
			# only take into account stuff which is really within the limits ofthe screen (plus a margin)
			# the radar can scan a bit outside of the range/azimuth
			if (math.abs(screen_pos[0]) < (RDR_DISPLAY_WIDTH/2 + TARGET_WIDTH) and math.abs(screen_pos[1]) < (RDR_DISPLAY_HEIGHT/2 + TARGET_WIDTH)) {
				append(me.radar_contacts_pos, screen_pos);
				append(me.radar_contacts, contact);
				# me.friend_contacts[i].hide(); # currently we do not know the friends
				if (contact.equalsFast(radar_system.apg68Radar.getPriorityTarget())) {
					has_priority = 1;
					me.selected_target.setTranslation(screen_pos[0], screen_pos[1]);
					# me.selected_target_callsign.updateText(contact.getCallsign());
					me.unknown_targets[i].hide();
					# me.gnd_targets[i].hide();
				} else {
					me.unknown_targets[i].setRotation(relative_heading_rad);
					me.unknown_targets[i].setTranslation(screen_pos[0], screen_pos[1]);
					me.unknown_targets[i].show();
					# me.gnd_targets[i].hide();
				}

				# Draw a line from the target to indicate the speed - only if faster than 50 kt, ca 25 m/s
				# Based on the pict from the book the selected target does not get a line, here we do
				# target_speed_m_s = contact.get_Speed() * KT2MPS;
				# if (target_speed_m_s > 25) {
				# 	delta = _calcTargetSpeedIndication(target_speed_m_s, relative_heading_rad);
				# 	me.targets_speeds[i] = me.targets_speed_group.createChild("path")
				# 	                                             .setColor(COLOR_RADAR)
				# 	                                             .moveTo(screen_pos[0] + delta[0], screen_pos[1] - delta[1])
				# 	                                             .lineTo(screen_pos[0] + delta[2], screen_pos[1] - delta[3])
				# 	                                             .setStrokeLineWidth(LINE_WIDTH);
				# 	me.targets_speeds[i].update(); # because targets_speed_group children get deleted in next frame
				# }
			}
			i += 1;
		}

		# handle the index positions if the target list was shorter than the reserved elements
		# for (var j = i; j < MAX_TARGETS; j += 1) {
		# 	# me.friend_contacts[j].hide();
		# 	me.unknown_targets[j].hide();
		# 	# me.gnd_targets[j].hide();
		# }
		me.selected_target.setVisible(has_priority);
		# me.selected_target_callsign.setVisible(has_priority);
		# me.sniped_target.setVisible(has_sniped_target);
		# me.sniped_target_prio.setVisible(sniped_target_is_priority);
	},

	_distCursorTrack: func(i) {
		return math.sqrt(
			math.pow(me.cursor_pos[0] - me.radar_contacts_pos[i][0], 2)
			+ math.pow(me.cursor_pos[1] - me.radar_contacts_pos[i][1], 2)
		);
	},

	_findCursorTrack: func() {
		var closest_i = nil;
		var min_dist = 100000;
		for (var i=0; i < size(me.radar_contacts); i+=1) {
			var dist = me._distCursorTrack(i);
			if (dist < min_dist) {
				closest_i = i;
				min_dist = dist;
			}
		}
		if (min_dist < TARGET_WIDTH/2) {
			return me.radar_contacts[closest_i];
		} else {
			return nil;
		}
	},



	update: func()
	{
		var max_azimuth_rad = radar_system.apg68Radar.getAzimuthRadius() * D2R;
		var max_distance_m = radar_system.apg68Radar.getRange() * NM2M;
		var radar_mode_root_name = radar_system.apg68Radar.currentMode.rootName;
		var radar_mode_name = radar_system.apg68Radar.getMode();

		me.horizonBar.setRotation(-radar_system.self.getRoll()*D2R);
		me.caretPosition = radar_system.apg68Radar.getCaretPosition();
		me.scan_line_horiz.setTranslation(me.caretPosition[0]*RDR_DISPLAY_WIDTH*0.5,0);
		me.acAltitude.updateText(sprintf("%01d",math.round(radar_system.self.getAltitude(),10)));
		# 	me.acSpeed.setText(sprintf("%03dKT", me.input.ias.getValue()));
		me.acHeading.updateText(radar_system.self.getHeading());
		me._updateCursor(max_azimuth_rad, max_distance_m, radar_mode_name);
		me._updateTargets(max_azimuth_rad, max_distance_m, radar_mode_name);
	},
};

# Calculates the relative screen position of a point in B-scope
# Returns the x/y position on the Canvas
var _calcScreenPositionBScopeToXY = func(distance_m, max_distance_m, angle_rad, max_azimuth_rad) {
	var x_pos = angle_rad / max_azimuth_rad * (0.5 * RDR_DISPLAY_WIDTH);
	var y_pos = (0.5 * RDR_DISPLAY_HEIGHT) - distance_m / max_distance_m * RDR_DISPLAY_HEIGHT;
	return [x_pos, y_pos];
};

# Calculates the relative screen position of a point in B-scope
# Returns the angle_rad/distance_m position on the Canvas
var _calcScreenPositionBScopeFromXY = func(x_pos, y_pos, max_distance_m, max_azimuth_rad) {
	var angle_rad = x_pos * max_azimuth_rad / (0.5 * RDR_DISPLAY_WIDTH);
	var distance_m = ((0.5 * RDR_DISPLAY_HEIGHT) - y_pos) * max_distance_m / RDR_DISPLAY_HEIGHT;
	return [angle_rad, distance_m];
};

# Calculates an indication of the speed and direction of a target.
# For each 100 m/s (ca. 200 kt) extra the length increases
var _calcTargetSpeedIndication = func(target_speed_m_s, relative_heading_rad) {
	# the start point
	var dist_away = 0.5 * TARGET_WIDTH;
	var x_start_delta = dist_away * math.sin(relative_heading_rad);
	var y_start_delta = dist_away * math.cos(relative_heading_rad);

	# the end point
	dist_away = dist_away + TARGET_WIDTH + math.floor(target_speed_m_s/100) * 0.5 * TARGET_WIDTH;
	var x_end_delta = dist_away * math.sin(relative_heading_rad);
	var y_end_delta = dist_away * math.cos(relative_heading_rad);
	return [x_start_delta, y_start_delta, x_end_delta, y_end_delta];
};
