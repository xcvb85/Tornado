var TvTabInstances = [{}, {}];

var PageEnum = {
	PLN:  0,
	NAV:  1,
	FA:   2,
	EQM:  3,
	EMT:  4,
};

var MenuEnum = {
	C09:  0,
	CAK:  1,
	CLV:  2,
	CWM:  3,
	REV:  4,
	PLN:  5,
	NAV:  6,
	FA:   7,
	DST:  8,
	DAT:  9,
	RTE: 10,
	EQM: 11,
};

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
		append(m.Pages, canvas_eqm.new(group.createChild('group'))); #3
		append(m.Pages, canvas_empty.new(group.createChild('group'))); #4

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
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(0, m, "0"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(1, m, "1"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(2, m, "2"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(3, m, "3"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(4, m, "4"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(5, m, "5"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(6, m, "6"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(7, m, "7"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(8, m, "8"));
		m.Menus[MenuEnum.C09].AddItem(SkCharItem.new(9, m, "9"));

		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(0, m, "A"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(1, m, "B"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(2, m, "C"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(3, m, "D"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(4, m, "E"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(5, m, "F"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(6, m, "G"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(7, m, "H"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(8, m, "J"));
		m.Menus[MenuEnum.CAK].AddItem(SkCharItem.new(9, m, "K"));

		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(0, m, "L"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(1, m, "M"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(2, m, "N"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(3, m, "P"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(4, m, "Q"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(5, m, "R"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(6, m, "S"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(7, m, "T"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(8, m, "U"));
		m.Menus[MenuEnum.CLV].AddItem(SkCharItem.new(9, m, "V"));

		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(0, m, "W"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(1, m, "X"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(2, m, "Y"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(3, m, "Z"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(4, m, "0"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(5, m, "ERAZ"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(8, m, "+"));
		m.Menus[MenuEnum.CWM].AddItem(SkCharItem.new(9, m, "-"));

		m.Menus[MenuEnum.REV].AddItem(SkItem.new(0, m, "WS"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(1, m, "WPT"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(2, m, "FXPT"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(3, m, "TGT"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(4, m, "LL"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(5, m, "ML"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(7, m, "NFX"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(8, m, "HTFX"));
		m.Menus[MenuEnum.REV].AddItem(SkItem.new(9, m, "FLW"));

		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(0, m, "MD1")); #PLN
		m.Menus[MenuEnum.PLN].AddItem(SkMenuActivateItem.new(1, m, "DEST", MenuEnum.DST));
		m.Menus[MenuEnum.PLN].AddItem(SkMenuActivateItem.new(2, m, "DATA", MenuEnum.DAT));
		m.Menus[MenuEnum.PLN].AddItem(SkMenuActivateItem.new(3, m, "RTE", MenuEnum.RTE));
		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(4, m, "POS"));
		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(5, m, "RESD"));
		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(7, m, "INT"));
		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(8, m, "FUEL"));
		m.Menus[MenuEnum.PLN].AddItem(SkItem.new(9, m, "IM"));

		m.Menus[MenuEnum.NAV].AddItem(SkScratchpadActivateItem.new(1, m, "WS", 0)); #NAV
		m.Menus[MenuEnum.NAV].AddItem(SkScratchpadActivateItem.new(1, m, "WPT", 1));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(2, m, "FXPT", 0));
		m.Menus[MenuEnum.NAV].AddItem(SkSwitchItem.new(4, m, "POS", "instrumentation/switch2"));
		m.Menus[MenuEnum.NAV].AddItem(SkSwitchItem.new(6, m, "MKR", "instrumentation/switch3"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(7, m, "INT"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(8, m, "NFX"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(9, m, "4/1"));

		m.Menus[MenuEnum.FA].AddItem(SkItem.new(0, m, "LL")); #FA
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(1, m, "ML"));
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(2, m, "ATTK"));
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(4, m, "POS"));
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(7, m, "PHF"));
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(8, m, "HTFX"));
		m.Menus[MenuEnum.FA].AddItem(SkItem.new(9, m, "4/1"));

		m.Menus[MenuEnum.DST].AddItem(SkItem.new(0, m, "WS")); #DEST
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(1, m, "WPT"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(2, m, "FXPT"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(3, m, "TGT"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(4, m, "OFS"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(5, m, "RESD"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(6, m, "MVT"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(7, m, "R B"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(8, m, "UTM"));
		m.Menus[MenuEnum.DST].AddItem(SkItem.new(9, m, "IM"));

		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(0, m, "K")); #DATA
		m.Menus[MenuEnum.DAT].AddItem(SkMenuPageActivateItem.new(1, m, "GTF", MenuEnum.EQM, PageEnum.EQM));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(2, m, "TIME"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(3, m, "TOT"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(4, m, "ALT"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(5, m, "GRID"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(6, m, "WV"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(7, m, "SYN"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(8, m, "SLDE"));
		m.Menus[MenuEnum.DAT].AddItem(SkItem.new(9, m, "IM"));

		m.Menus[MenuEnum.RTE].AddItem(SkMenuActivateItem.new(1, m, "DEST", MenuEnum.DST)); #RTE
		m.Menus[MenuEnum.RTE].AddItem(SkMenuActivateItem.new(2, m, "DATA", MenuEnum.DAT));
		m.Menus[MenuEnum.RTE].AddItem(SkItem.new(3, m, "RTE"));
		m.Menus[MenuEnum.RTE].AddItem(SkItem.new(4, m, "DTG"));
		m.Menus[MenuEnum.RTE].AddItem(SkItem.new(5, m, "RESD"));
		m.Menus[MenuEnum.RTE].AddItem(SkItem.new(7, m, "DEL"));
		m.Menus[MenuEnum.RTE].AddItem(SkItem.new(8, m, "INSR"));
		m.Menus[MenuEnum.RTE].AddItem(SkItem.new(9, m, "FLW"));

		m.Menus[MenuEnum.EQM].AddItem(SkItem.new(3, m, "IFM"));
		m.Menus[MenuEnum.EQM].AddItem(SkItem.new(4, m, "IDD"));
		m.Menus[MenuEnum.EQM].AddItem(SkItem.new(5, m, "OFP"));
		m.Menus[MenuEnum.EQM].AddItem(SkItem.new(6, m, "SSD"));
		m.Menus[MenuEnum.EQM].AddItem(SkItem.new(7, m, "TST"));
		m.Menus[MenuEnum.EQM].AddItem(SkItem.new(8, m, "ACC"));

		m.Timer = maketimer(1.0, m, m.update);
		m.Timer.start();
		return m;
	},
	update: func()
	{
		me.SkInstance.update();
		me.Pages[me.ActivePage].update();
	}
};

var bak = 0;
var tvTabBtClick = func(index = 0, input = -1) {

	if (input < 10) {
		TvTabInstances[index].BtClick(input);
	}
	else {
		if (input == 10) {
			if(plnInUse == 0 or plnInUse == index+1) {
				TvTabInstances[index].ActivatePage(PageEnum.PLN); #PLN
				TvTabInstances[index].ActivateMenu(MenuEnum.PLN);
				plnInUse = index+1;
			}
		}
		else if (input == 11) {
			TvTabInstances[index].ActivatePage(PageEnum.NAV); #NAV
			TvTabInstances[index].ActivateMenu(MenuEnum.NAV);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 12) {
			TvTabInstances[index].ActivatePage(PageEnum.FA); #FA
			TvTabInstances[index].ActivateMenu(MenuEnum.FA);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 17) {
			TvTabInstances[index].ActivatePage(PageEnum.EMT); #TVM - Missile TV
			TvTabInstances[index].ActivateMenu(MenuEnum.REV);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 18) {
			TvTabInstances[index].ActivatePage(PageEnum.EMT); #RCN - RECCE camera
			TvTabInstances[index].ActivateMenu(MenuEnum.REV);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 13) {
			if (TvTabInstances[index].GetActiveMenu() != 1) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.CAK); #A-K
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 14) {
			if (TvTabInstances[index].GetActiveMenu() != 2) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.CLV); #L-V
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 15) {
			if (TvTabInstances[index].GetActiveMenu() != 3) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.CWM); #W-Z
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 20) {
			if (TvTabInstances[index].GetActiveMenu() != 0) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.C09); #0-9
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

var tvTab1Knob = func(input = -1) {
}

tvTabListener = setlistener("/sim/signals/fdm-initialized", func () {

	var tvTab1Canvas = canvas.new({
		"name": "TVTAB1",
		"size": [512, 512],
		"view": [310, 250],
		"mipmapping": 1
	});
	var tvTab2Canvas = canvas.new({
		"name": "TVTAB1",
		"size": [512, 512],
		"view": [310, 250],
		"mipmapping": 1
	});

	tvTab1Canvas.addPlacement({"node": "TVTAB1.screen"});
	tvTab2Canvas.addPlacement({"node": "TVTAB2.screen"});
	TvTabInstances[0] = TVTAB.new(tvTab1Canvas.createGroup(), 0);
	TvTabInstances[1] = TVTAB.new(tvTab2Canvas.createGroup(), 0);

	removelistener(tvTabListener);
	tvTabBtClick(0, 10);
	tvTabBtClick(1, 11);
});
