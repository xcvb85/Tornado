var TvTabInstances = [];

var tvTabListener = 0;

var TVTAB = {
	new: func(group, instance)
	{
		var m = { parents: [TVTAB, Device.new(instance)] };

		# create pages
		append(m.Pages, canvas_plan.new(group.createChild('group'))); #0
		append(m.Pages, canvas_nav.new(group.createChild('group'))); #1
		append(m.Pages, canvas_rdr.new(group.createChild('group'))); #2
		append(m.Pages, canvas_empty.new(group.createChild('group'))); #3

		m.SkInstance = canvas_softkeys.new(group.createChild('group'));

		# create menus
		append(m.Menus, SkMenu.new(0, m, ""));
		append(m.Menus, SkMenu.new(1, m, ""));
		append(m.Menus, SkMenu.new(2, m, ""));
		append(m.Menus, SkMenu.new(3, m, ""));
		append(m.Menus, SkMenu.new(4, m, ""));
		append(m.Menus, SkMenu.new(5, m, ""));
		append(m.Menus, SkMenu.new(6, m, ""));

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
		m.Menus[2].AddItem(SkItem.new(9, m, "W"));

		m.Menus[3].AddItem(SkItem.new(0, m, "WS"));
		m.Menus[3].AddItem(SkItem.new(1, m, "WPT"));
		m.Menus[3].AddItem(SkItem.new(2, m, "FXPT"));
		m.Menus[3].AddItem(SkItem.new(3, m, "TGT"));
		m.Menus[3].AddItem(SkItem.new(4, m, "LL"));
		m.Menus[3].AddItem(SkItem.new(5, m, "ML"));
		m.Menus[3].AddItem(SkItem.new(6, m, "MKR"));
		m.Menus[3].AddItem(SkItem.new(7, m, "NFX"));
		m.Menus[3].AddItem(SkItem.new(8, m, "HTFX"));
		m.Menus[3].AddItem(SkItem.new(9, m, "FLW"));

		m.Menus[4].AddItem(SkItem.new(1, m, "NVPT")); #PLN
		m.Menus[4].AddItem(SkItem.new(2, m, "GRPH"));
		m.Menus[4].AddItem(SkItem.new(3, m, "SEC"));
		m.Menus[4].AddItem(SkItem.new(4, m, "FUEL"));
		m.Menus[4].AddItem(SkItem.new(5, m, "SURV"));
		m.Menus[4].AddItem(SkItem.new(6, m, "HDG"));
		m.Menus[4].AddItem(SkItem.new(7, m, "DL1"));
		m.Menus[4].AddItem(SkItem.new(8, m, "X2"));
		m.Menus[4].AddItem(SkItem.new(9, m, "X/2"));

		m.Menus[5].AddItem(SkItem.new(1, m, "POI")); #NAV
		m.Menus[5].AddItem(SkItem.new(2, m, "FXPT"));
		m.Menus[5].AddItem(SkItem.new(3, m, "NVWR"));
		m.Menus[5].AddItem(SkItem.new(4, m, "SPD"));
		m.Menus[5].AddItem(SkItem.new(5, m, "WKTK"));
		m.Menus[5].AddItem(SkItem.new(6, m, "PIN"));
		m.Menus[5].AddItem(SkItem.new(7, m, "WIND"));
		m.Menus[5].AddItem(SkItem.new(8, m, "TIME"));
		m.Menus[5].AddItem(SkItem.new(9, m, "SEL4"));

		m.Menus[6].AddItem(SkItem.new(1, m, "AWS")); #RDR
		m.Menus[6].AddItem(SkItem.new(2, m, "GRID"));
		m.Menus[6].AddItem(SkItem.new(3, m, "ATWS"));
		m.Menus[6].AddItem(SkItem.new(4, m, "DUMP"));
		m.Menus[6].AddItem(SkItem.new(5, m, "EXCH"));
		m.Menus[6].AddItem(SkItem.new(7, m, "MACH"));
		m.Menus[6].AddItem(SkItem.new(8, m, "ASYP"));
		m.Menus[6].AddItem(SkItem.new(9, m, "ATK"));

		m.ActivatePage(0, 0);
		m.ActivateMenu(4);
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
			TvTabInstances[index].ActivatePage(0, 0); #PLN
			TvTabInstances[index].ActivateMenu(4);
		}
		else if (input == 11) {
			TvTabInstances[index].ActivatePage(1, 0); #NAV
			TvTabInstances[index].ActivateMenu(5);
		}
		else if (input == 12) {
			TvTabInstances[index].ActivatePage(3, 0); #F
			TvTabInstances[index].ActivateMenu(3);
		}
		else if (input == 17) {
			TvTabInstances[index].ActivatePage(3, 0); #VAS
			TvTabInstances[index].ActivateMenu(3);
		}
		else if (input == 18) {
			TvTabInstances[index].ActivatePage(2, 0); #RDR
			TvTabInstances[index].ActivateMenu(6);
		}
		else if (input == 14) {
			if (TvTabInstances[index].GetActiveMenu() > 3) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(1); #A-K
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 15) {
			if (TvTabInstances[index].GetActiveMenu() > 3) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(2); #L-W
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 20) {
			if (TvTabInstances[index].GetActiveMenu() > 3) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(0); #0-9
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 21) {
			if (TvTabInstances[index].GetActiveMenu() < 4) {
				TvTabInstances[index].ActivateMenu(bak); #Enter
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
	var tvTav2Canvas = canvas.new({
		"name": "TVTAB1",
		"size": [512, 512],
		"view": [310, 250],
		"mipmapping": 1
	});

	tvTav1Canvas.addPlacement({"node": "TVTAB1.screen"});
	tvTav2Canvas.addPlacement({"node": "TVTAB2.screen"});
	tvTav1Canvas.addPlacement({"node": "EHDD1.screen"});
	tvTav2Canvas.addPlacement({"node": "EHDD2.screen"});
	append(TvTabInstances, TVTAB.new(tvTav1Canvas.createGroup(), 0));
	append(TvTabInstances, TVTAB.new(tvTav2Canvas.createGroup(), 0));
	removelistener(tvTabListener);
});
