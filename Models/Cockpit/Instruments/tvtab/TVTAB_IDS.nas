var TvTabInstances = [{}, {}];

var tvTabListener = 0;
var plnInUse = 0; # 0=free, 1=left, 2=right

var TVTAB = {
	new: func(group, instance)
	{
		var m = { parents: [TVTAB, Device.new(instance)] };

		# create pages
		append(m.Pages, canvas_plan.new(group.createChild('group'))); #0
		append(m.Pages, canvas_nav.new(group.createChild('group'))); #1
		append(m.Pages, canvas_fa.new(group.createChild('group'))); #2
		append(m.Pages, canvas_empty.new(group.createChild('group'))); #3
		append(m.Pages, canvas_eqm.new(group.createChild('group'))); #4

		m.SkInstance = canvas_overlay.new(group.createChild('group'));

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
		append(m.Menus, SkMenu.new(11, m, ""));

		# create softkeys
		m.Menus[0].AddItem(SkCharItem.new(0, m, "0"));
		m.Menus[0].AddItem(SkCharItem.new(1, m, "1"));
		m.Menus[0].AddItem(SkCharItem.new(2, m, "2"));
		m.Menus[0].AddItem(SkCharItem.new(3, m, "3"));
		m.Menus[0].AddItem(SkCharItem.new(4, m, "4"));
		m.Menus[0].AddItem(SkCharItem.new(5, m, "5"));
		m.Menus[0].AddItem(SkCharItem.new(6, m, "6"));
		m.Menus[0].AddItem(SkCharItem.new(7, m, "7"));
		m.Menus[0].AddItem(SkCharItem.new(8, m, "8"));
		m.Menus[0].AddItem(SkCharItem.new(9, m, "9"));

		m.Menus[1].AddItem(SkCharItem.new(0, m, "A"));
		m.Menus[1].AddItem(SkCharItem.new(1, m, "B"));
		m.Menus[1].AddItem(SkCharItem.new(2, m, "C"));
		m.Menus[1].AddItem(SkCharItem.new(3, m, "D"));
		m.Menus[1].AddItem(SkCharItem.new(4, m, "E"));
		m.Menus[1].AddItem(SkCharItem.new(5, m, "F"));
		m.Menus[1].AddItem(SkCharItem.new(6, m, "G"));
		m.Menus[1].AddItem(SkCharItem.new(7, m, "H"));
		m.Menus[1].AddItem(SkCharItem.new(8, m, "J"));
		m.Menus[1].AddItem(SkCharItem.new(9, m, "K"));

		m.Menus[2].AddItem(SkCharItem.new(0, m, "L"));
		m.Menus[2].AddItem(SkCharItem.new(1, m, "M"));
		m.Menus[2].AddItem(SkCharItem.new(2, m, "N"));
		m.Menus[2].AddItem(SkCharItem.new(3, m, "P"));
		m.Menus[2].AddItem(SkCharItem.new(4, m, "Q"));
		m.Menus[2].AddItem(SkCharItem.new(5, m, "R"));
		m.Menus[2].AddItem(SkCharItem.new(6, m, "S"));
		m.Menus[2].AddItem(SkCharItem.new(7, m, "T"));
		m.Menus[2].AddItem(SkCharItem.new(8, m, "U"));
		m.Menus[2].AddItem(SkCharItem.new(9, m, "V"));

		m.Menus[3].AddItem(SkCharItem.new(0, m, "W"));
		m.Menus[3].AddItem(SkCharItem.new(1, m, "X"));
		m.Menus[3].AddItem(SkCharItem.new(2, m, "Y"));
		m.Menus[3].AddItem(SkCharItem.new(3, m, "Z"));
		m.Menus[3].AddItem(SkCharItem.new(4, m, "0"));
		m.Menus[3].AddItem(SkCharItem.new(5, m, "ERAZ"));
		m.Menus[3].AddItem(SkCharItem.new(8, m, "+"));
		m.Menus[3].AddItem(SkCharItem.new(9, m, "-"));

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

		m.Menus[6].AddItem(SkScratchpadActivateItem.new(1, m, "WS", 0)); #NAV
		m.Menus[6].AddItem(SkScratchpadActivateItem.new(1, m, "WPT", 1));
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
		m.Menus[9].AddItem(SkMenuPageActivateItem.new(1, m, "GTF", 11, 4));
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

		m.Menus[11].AddItem(SkItem.new(3, m, "IFM"));
		m.Menus[11].AddItem(SkItem.new(4, m, "IDD"));
		m.Menus[11].AddItem(SkItem.new(5, m, "OFP"));
		m.Menus[11].AddItem(SkItem.new(6, m, "SSD"));
		m.Menus[11].AddItem(SkItem.new(7, m, "TST"));
		m.Menus[11].AddItem(SkItem.new(8, m, "ACC"));

		return m;
	}
};

var bak = 0;
var tvTavBtClick = func(index = 0, input = -1) {

	if (input < 10) {
		TvTabInstances[index].BtClick(input);
	}
	else {
		if (input == 10) {
			if(plnInUse == 0 or plnInUse == index+1) {
				TvTabInstances[index].ActivatePage(0, 0); #PLN
				TvTabInstances[index].ActivateMenu(5);
				plnInUse = index+1;
			}
		}
		else if (input == 11) {
			TvTabInstances[index].ActivatePage(1, 0); #NAV
			TvTabInstances[index].ActivateMenu(6);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 12) {
			TvTabInstances[index].ActivatePage(2, 0); #FA
			TvTabInstances[index].ActivateMenu(7);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 17) {
			TvTabInstances[index].ActivatePage(3, 0); #TVM - Missile TV
			TvTabInstances[index].ActivateMenu(4);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 18) {
			TvTabInstances[index].ActivatePage(3, 0); #RCN - RECCE camera
			TvTabInstances[index].ActivateMenu(4);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 13) {
			if (TvTabInstances[index].GetActiveMenu() != 1) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(1); #A-K
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 14) {
			if (TvTabInstances[index].GetActiveMenu() != 2) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(2); #L-V
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 15) {
			if (TvTabInstances[index].GetActiveMenu() != 3) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(3); #W-Z
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 20) {
			if (TvTabInstances[index].GetActiveMenu() != 0) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(0); #0-9
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 21) {
			TvTabInstances[index].SetCharacter("\n"); #Enter
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
	var tvTav2Canvas = canvas.new({
		"name": "TVTAB1",
		"size": [512, 512],
		"view": [310, 250],
		"mipmapping": 1
	});

	tvTav1Canvas.addPlacement({"node": "TVTAB1.screen"});
	tvTav2Canvas.addPlacement({"node": "TVTAB2.screen"});
	TvTabInstances[0] = TVTAB.new(tvTav1Canvas.createGroup(), 0);
	TvTabInstances[1] = TVTAB.new(tvTav2Canvas.createGroup(), 0);

	removelistener(tvTabListener);
	tvTavBtClick(0, 10);
	tvTavBtClick(1, 11);
});
