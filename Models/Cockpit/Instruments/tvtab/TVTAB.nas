var TvTab1Instance = {};
var TvTab2Instance = {};

var tvTabListener = 0;

var TVTAB = {
	new: func(group, instance)
	{
		var m = { parents: [TVTAB, Device.new(instance)] };

		# create pages
		append(m.Pages, canvas_plan.new(group.createChild('group'))); #0
		append(m.Pages, canvas_nav.new(group.createChild('group'))); #1
		append(m.Pages, canvas_rdr.new(group.createChild('group'))); #2

		m.SkInstance = canvas_softkeys.new(group.createChild('group'));

		# create menus
		append(m.Menus, SkMenu.new(0, m, ""));
		append(m.Menus, SkMenu.new(1, m, ""));
		append(m.Menus, SkMenu.new(2, m, ""));
		append(m.Menus, SkMenu.new(3, m, ""));
		append(m.Menus, SkMenu.new(4, m, ""));
		append(m.Menus, SkMenu.new(5, m, ""));
		append(m.Menus, SkMenu.new(6, m, ""));
		append(m.Menus, SkMenu.new(7, m, ""));
		append(m.Menus, SkMenu.new(8, m, ""));
		append(m.Menus, SkMenu.new(9, m, ""));
		append(m.Menus, SkMenu.new(10, m, ""));

		# create softkeys
		m.Menus[0].AddItem(SkItem.new(0, m, "0"));
		m.Menus[0].AddItem(SkItem.new(1, m, "1"));
		m.Menus[0].AddItem(SkItem.new(2, m, "2"));
		m.Menus[0].AddItem(SkItem.new(3, m, "3"));
		m.Menus[0].AddItem(SkItem.new(4, m, "4"));
		m.Menus[0].AddItem(SkItem.new(5, m, "5"));
		m.Menus[0].AddItem(SkItem.new(6, m, "6"));
		m.Menus[0].AddItem(SkItem.new(7, m, "7"));
		m.Menus[0].AddItem(SkItem.new(8, m, "8"));
		m.Menus[0].AddItem(SkItem.new(9, m, "9"));

		m.Menus[1].AddItem(SkItem.new(0, m, "A"));
		m.Menus[1].AddItem(SkItem.new(1, m, "B"));
		m.Menus[1].AddItem(SkItem.new(2, m, "C"));
		m.Menus[1].AddItem(SkItem.new(3, m, "D"));
		m.Menus[1].AddItem(SkItem.new(4, m, "E"));
		m.Menus[1].AddItem(SkItem.new(5, m, "F"));
		m.Menus[1].AddItem(SkItem.new(6, m, "G"));
		m.Menus[1].AddItem(SkItem.new(7, m, "H"));
		m.Menus[1].AddItem(SkItem.new(8, m, "J"));
		m.Menus[1].AddItem(SkItem.new(9, m, "K"));

		m.Menus[2].AddItem(SkItem.new(0, m, "L"));
		m.Menus[2].AddItem(SkItem.new(1, m, "M"));
		m.Menus[2].AddItem(SkItem.new(2, m, "N"));
		m.Menus[2].AddItem(SkItem.new(3, m, "P"));
		m.Menus[2].AddItem(SkItem.new(4, m, "Q"));
		m.Menus[2].AddItem(SkItem.new(5, m, "R"));
		m.Menus[2].AddItem(SkItem.new(6, m, "S"));
		m.Menus[2].AddItem(SkItem.new(7, m, "T"));
		m.Menus[2].AddItem(SkItem.new(8, m, "U"));
		m.Menus[2].AddItem(SkItem.new(9, m, "V"));

		m.Menus[3].AddItem(SkItem.new(0, m, "W"));
		m.Menus[3].AddItem(SkItem.new(1, m, "X"));
		m.Menus[3].AddItem(SkItem.new(2, m, "Y"));
		m.Menus[3].AddItem(SkItem.new(3, m, "Z"));
		m.Menus[3].AddItem(SkItem.new(4, m, "0"));
		m.Menus[3].AddItem(SkItem.new(5, m, "ERAZ"));
		m.Menus[3].AddItem(SkItem.new(8, m, "+"));
		m.Menus[3].AddItem(SkItem.new(9, m, "-"));

		m.Menus[4].AddItem(SkItem.new(0, m, "WS"));
		m.Menus[4].AddItem(SkItem.new(1, m, "WPT"));
		m.Menus[4].AddItem(SkItem.new(2, m, "FXPT"));
		m.Menus[4].AddItem(SkItem.new(3, m, "TGT"));
		m.Menus[4].AddItem(SkItem.new(4, m, "LL"));
		m.Menus[4].AddItem(SkItem.new(5, m, "ML"));
		m.Menus[4].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[4].AddItem(SkItem.new(7, m, "NFX"));
		m.Menus[4].AddItem(SkItem.new(8, m, "HTFX"));
		m.Menus[4].AddItem(SkItem.new(9, m, "FLW"));

		m.Menus[5].AddItem(SkItem.new(0, m, "MD1")); #PLN
		m.Menus[5].AddItem(SkMenuActivateItem.new(1, m, "DEST", 8));
		m.Menus[5].AddItem(SkMenuActivateItem.new(2, m, "DATA", 9));
		m.Menus[5].AddItem(SkMenuActivateItem.new(3, m, "RTE", 10));
		m.Menus[5].AddItem(SkItem.new(4, m, "POS"));
		m.Menus[5].AddItem(SkItem.new(5, m, "RESD"));
		m.Menus[5].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[5].AddItem(SkItem.new(7, m, "INT"));
		m.Menus[5].AddItem(SkItem.new(8, m, "FUEL"));
		m.Menus[5].AddItem(SkItem.new(9, m, "IM"));

		m.Menus[6].AddItem(SkSwitchItem.new(0, m, "WS", "instrumentation/switch1")); #NAV
		m.Menus[6].AddItem(SkItem.new(1, m, "WPT", 0));
		m.Menus[6].AddItem(SkItem.new(2, m, "FXPT", 0));
		m.Menus[6].AddItem(SkSwitchItem.new(4, m, "POS", "instrumentation/switch2"));
		m.Menus[6].AddItem(SkSwitchItem.new(6, m, "MKR", "instrumentation/switch3"));
		m.Menus[6].AddItem(SkItem.new(7, m, "INT"));
		m.Menus[6].AddItem(SkItem.new(8, m, "NFX"));
		m.Menus[6].AddItem(SkItem.new(9, m, "4/1"));

		m.Menus[7].AddItem(SkItem.new(0, m, "LL")); #FA
		m.Menus[7].AddItem(SkItem.new(1, m, "ML"));
		m.Menus[7].AddItem(SkItem.new(2, m, "ATTK"));
		m.Menus[7].AddItem(SkItem.new(4, m, "POS"));
		m.Menus[7].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[7].AddItem(SkItem.new(7, m, "PHF"));
		m.Menus[7].AddItem(SkItem.new(8, m, "HTFX"));
		m.Menus[7].AddItem(SkItem.new(9, m, "4/1"));

		m.Menus[8].AddItem(SkItem.new(0, m, "WS")); #DEST
		m.Menus[8].AddItem(SkItem.new(1, m, "WPT"));
		m.Menus[8].AddItem(SkItem.new(2, m, "FXPT"));
		m.Menus[8].AddItem(SkItem.new(3, m, "TGT"));
		m.Menus[8].AddItem(SkItem.new(4, m, "OFS"));
		m.Menus[8].AddItem(SkItem.new(5, m, "RESD"));
		m.Menus[8].AddItem(SkItem.new(6, m, "MVT"));
		m.Menus[8].AddItem(SkItem.new(7, m, "R B"));
		m.Menus[8].AddItem(SkItem.new(8, m, "UTM"));
		m.Menus[8].AddItem(SkItem.new(9, m, "IM"));

		m.Menus[9].AddItem(SkItem.new(0, m, "K")); #DATA
		m.Menus[9].AddItem(SkItem.new(1, m, "GTF"));
		m.Menus[9].AddItem(SkItem.new(2, m, "TIME"));
		m.Menus[9].AddItem(SkItem.new(3, m, "TOT"));
		m.Menus[9].AddItem(SkItem.new(4, m, "ALT"));
		m.Menus[9].AddItem(SkItem.new(5, m, "GRID"));
		m.Menus[9].AddItem(SkItem.new(6, m, "WV"));
		m.Menus[9].AddItem(SkItem.new(7, m, "SYN"));
		m.Menus[9].AddItem(SkItem.new(8, m, "SLDE"));
		m.Menus[9].AddItem(SkItem.new(9, m, "IM"));

		m.Menus[10].AddItem(SkMenuActivateItem.new(1, m, "DEST", 8)); #RTE
		m.Menus[10].AddItem(SkMenuActivateItem.new(2, m, "DATA", 9));
		m.Menus[10].AddItem(SkItem.new(3, m, "RTE"));
		m.Menus[10].AddItem(SkItem.new(4, m, "DTG"));
		m.Menus[10].AddItem(SkItem.new(5, m, "RESD"));
		m.Menus[10].AddItem(SkItem.new(7, m, "DEL"));
		m.Menus[10].AddItem(SkItem.new(8, m, "INSR"));
		m.Menus[10].AddItem(SkItem.new(9, m, "FLW"));

		m.ActivatePage(0, 0);
		m.ActivateMenu(4);
		return m;
	}
};

var bak = 0;
var tvTav1BtClick = func(input = -1) {

	if (input < 10) {
		TvTab1Instance.BtClick(input);
	}
	else {
		if (input == 10) {
			TvTab1Instance.ActivatePage(0, 0); #PLN
			TvTab1Instance.ActivateMenu(5);
		}
		else if (input == 11) {
			TvTab1Instance.ActivatePage(1, 0); #NAV
			TvTab1Instance.ActivateMenu(6);
		}
		else if (input == 12) {
			TvTab1Instance.ActivatePage(2, 0); #FA
			TvTab1Instance.ActivateMenu(7);
		}
		else if (input == 13) {
			if (TvTab1Instance.GetActiveMenu() > 3) {
				bak = TvTab1Instance.GetActiveMenu();
				TvTab1Instance.ActivateMenu(1); #A-K
			}
			else {
				TvTab1Instance.ActivateMenu(bak);
			}
		}
		else if (input == 14) {
			if (TvTab1Instance.GetActiveMenu() > 3) {
				bak = TvTab1Instance.GetActiveMenu();
				TvTab1Instance.ActivateMenu(2); #L-V
			}
			else {
				TvTab1Instance.ActivateMenu(bak);
			}
		}
		else if (input == 15) {
			if (TvTab1Instance.GetActiveMenu() > 3) {
				bak = TvTab1Instance.GetActiveMenu();
				TvTab1Instance.ActivateMenu(3); #W-Z
			}
			else {
				TvTab1Instance.ActivateMenu(bak);
			}
		}
		else if (input == 20) {
			if (TvTab1Instance.GetActiveMenu() > 3) {
				bak = TvTab1Instance.GetActiveMenu();
				TvTab1Instance.ActivateMenu(0); #0-9
			}
			else {
				TvTab1Instance.ActivateMenu(bak);
			}
		}
		else if (input == 21) {
			if (TvTab1Instance.GetActiveMenu() < 4) {
				TvTab1Instance.ActivateMenu(bak); #Enter
			}
		}
	}
}

var tvTav1Knob = func(input = -1) {
}

tvTabListener = setlistener("/sim/signals/fdm-initialized", func () {

	var tvTav1Canvas = canvas.new({
		"name": "TVTAB1",
		"size": [512, 512],
		"view": [310, 250],
		"mipmapping": 1
	});
	tvTav1Canvas.addPlacement({"node": "TAB1SCREEN"});
	TvTab1Instance = TVTAB.new(tvTav1Canvas.createGroup(), 0);

	removelistener(tvTabListener);
});
