var TvTabInstances = [];

var PageEnum = {
	PLN:  0,
	NAV:  1,
	RDR:  2,
	EMT:  3,
};

var MenuEnum = {
	C09:  0,
	CAK:  1,
	CLW:  2,
	IOQ:  3,
	TAB:  4,
	GWS:  5,
	NAV:  6,
	PRI:  7,
	SEC:  8,
	DL1:  9,
	DL2: 10,
	GRH: 11,
	UTL: 12,
	TWS: 13,
	PLS: 14,
	AWS: 15,
	RDS: 16,
	LCK: 17,
	RDE: 18,
};

var tvTabListener = 0;
var plnInUse = 0; # 0=free, 1=left, 2=right

var TVTAB = {
	new: func(group, instance)
	{
		var m = { parents: [TVTAB, Device.new(instance)] };

		# create pages
		append(m.Pages, canvas_plan.new(group.createChild('group')));
		append(m.Pages, canvas_nav.new(group.createChild('group')));
		append(m.Pages, canvas_rdr.new(group.createChild('group')));
		append(m.Pages, canvas_empty.new(group.createChild('group')));

		m.SkInstance = canvas_overlay.new(group.createChild('group'));

		# create menus
		append(m.Menus, SkMenu.new(MenuEnum.C09, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.CAK, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.CLW, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.IOQ, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.TAB, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.GWS, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.NAV, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.PRI, m, "PRIM"));
		append(m.Menus, SkMenu.new(MenuEnum.SEC, m, "SEC"));
		append(m.Menus, SkMenu.new(MenuEnum.DL1, m, "DL1"));
		append(m.Menus, SkMenu.new(MenuEnum.DL2, m, "DL2"));
		append(m.Menus, SkMenu.new(MenuEnum.GRH, m, "GRPH"));
		append(m.Menus, SkMenu.new(MenuEnum.UTL, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.TWS, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.PLS, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.AWS, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.RDS, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.LCK, m, ""));
		append(m.Menus, SkMenu.new(MenuEnum.RDE, m, ""));

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

		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(0, m, "L"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(1, m, "M"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(2, m, "N"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(3, m, "P"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(4, m, "Q"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(5, m, "R"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(6, m, "S"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(7, m, "T"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(8, m, "U"));
		m.Menus[MenuEnum.CLW].AddItem(SkCharItem.new(9, m, "W"));

		m.Menus[MenuEnum.IOQ].AddItem(SkCharItem.new(0, m, "I"));
		m.Menus[MenuEnum.IOQ].AddItem(SkCharItem.new(1, m, "O"));
		m.Menus[MenuEnum.IOQ].AddItem(SkCharItem.new(2, m, "Q"));
		m.Menus[MenuEnum.IOQ].AddItem(SkCharItem.new(3, m, "X"));
		m.Menus[MenuEnum.IOQ].AddItem(SkCharItem.new(4, m, "Y"));
		m.Menus[MenuEnum.IOQ].AddItem(SkCharItem.new(5, m, "Z"));
		m.Menus[MenuEnum.IOQ].AddItem(SkItem.new(8, m, "CHNG"));
		m.Menus[MenuEnum.IOQ].AddItem(SkItem.new(9, m, "L2"));

		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(0, m, "PAGE"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(1, m, "GPWS"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(2, m, "VOC"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(3, m, "AFB"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(4, m, "FUEL"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(5, m, "EXER"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(7, m, "MRM"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(8, m, "SNAG"));
		m.Menus[MenuEnum.TAB].AddItem(SkItem.new(9, m, "COLR"));

		m.Menus[MenuEnum.GWS].AddItem(SkItem.new(0, m, "MCH"));
		m.Menus[MenuEnum.GWS].AddItem(SkItem.new(4, m, "OBS"));
		m.Menus[MenuEnum.GWS].AddItem(SkMenuActivateItem.new(9, m, "PRIM", MenuEnum.PRI));

		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(0, m, "POS"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(1, m, "FXPT"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(2, m, "WIND"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(3, m, "MVAR"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(4, m, "SPD"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(5, m, "NXTK"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(6, m, "PIN"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(7, m, "MACH"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(8, m, "TIME"));
		m.Menus[MenuEnum.NAV].AddItem(SkItem.new(9, m, "SCL4"));

		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(0, m, "TRK"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(1, m, "NVPT"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(2, m, "GRPH"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(3, m, "SEC"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(4, m, "FUEL"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(5, m, "SURV"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(6, m, "HDG"));
		m.Menus[MenuEnum.PRI].AddItem(SkMenuActivateItem.new(7, m, "DL1", MenuEnum.DL1));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(8, m, "X2"));
		m.Menus[MenuEnum.PRI].AddItem(SkItem.new(9, m, "X/2"));

		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(0, m, "POS"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(1, m, "TRS"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(2, m, "TACN"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(3, m, "AFB"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(4, m, "ALTP"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(5, m, "TNK"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(6, m, "MEZ"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(7, m, "MAG"));
		m.Menus[MenuEnum.SEC].AddItem(SkItem.new(8, m, "FILT"));
		m.Menus[MenuEnum.SEC].AddItem(SkMenuActivateItem.new(9, m, "PRIM", MenuEnum.PRI));

		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(0, m, "ENG"));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(1, m, "DISG"));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(2, m, "INVS"));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(3, m, "PNTR"));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(4, m, "ALLY"));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(5, m, "UNKN"));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(6, m, "HOST"));
		m.Menus[MenuEnum.DL1].AddItem(SkMenuActivateItem.new(7, m, "DL2", MenuEnum.DL2));
		m.Menus[MenuEnum.DL1].AddItem(SkItem.new(8, m, "OFST"));
		m.Menus[MenuEnum.DL1].AddItem(SkMenuActivateItem.new(9, m, "PRIM", MenuEnum.PRI));

		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(0, m, "COOP"));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(1, m, "TN"));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(2, m, "HDUP"));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(3, m, "FUEL"));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(4, m, "SAVE"));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(5, m, "REJ"));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(6, m, "DLFP"));
		m.Menus[MenuEnum.DL2].AddItem(SkMenuActivateItem.new(7, m, "DL1", MenuEnum.DL1));
		m.Menus[MenuEnum.DL2].AddItem(SkItem.new(8, m, "REL"));
		m.Menus[MenuEnum.DL2].AddItem(SkMenuActivateItem.new(9, m, "PRIM", MenuEnum.PRI));

		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(0, m, "RTE"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(1, m, "LINE"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(2, m, "COAS"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(3, m, "DLRT"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(4, m, "NTH"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(5, m, "EDIT"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(6, m, "SCAN"));
		m.Menus[MenuEnum.GRH].AddItem(SkItem.new(7, m, "GMKR"));
		m.Menus[MenuEnum.GRH].AddItem(SkMenuActivateItem.new(9, m, "PRIM", MenuEnum.PRI));

		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(0, m, "DATA"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(1, m, "PGNS"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(2, m, "GREF"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(3, m, "R/B"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(4, m, "CAP"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(5, m, "ALOC"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(6, m, "MVG"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(7, m, "TTG"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(8, m, "IOQ"));
		m.Menus[MenuEnum.UTL].AddItem(SkItem.new(9, m, "DL1"));

		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(0, m, "DCL"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(1, m, "AWS"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(2, m, "SEC"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(3, m, "ATWS"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(4, m, "DUMP"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(5, m, "EXCH"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(6, m, "NORM"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(7, m, "MACH"));
		m.Menus[MenuEnum.TWS].AddItem(SkItem.new(9, m, "ATK"));

		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(0, m, "DCL"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(1, m, "AWS"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(2, m, "SEC"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(3, m, "SYM"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(4, m, "DUMP"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(5, m, "EXCH"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(6, m, "SHGT"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(7, m, "MACH"));
		m.Menus[MenuEnum.PLS].AddItem(SkItem.new(9, m, "ATK"));

		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(0, m, "DCL"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(1, m, "TWS"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(2, m, "SEC"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(3, m, "ATWS"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(4, m, "VEL"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(5, m, "RSET"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(6, m, "CHNG"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(7, m, "MACH"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(8, m, "SCHI"));
		m.Menus[MenuEnum.AWS].AddItem(SkItem.new(9, m, "ATK"));

		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(0, m, "DCL"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(1, m, "CFIR"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(2, m, "SEC"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(3, m, "TPR"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(4, m, "VEL"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(5, m, "PART"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(6, m, "CHNG"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(7, m, "MACH"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(8, m, "SCHI"));
		m.Menus[MenuEnum.LCK].AddItem(SkItem.new(9, m, "ATK"));

		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(0, m, "MVAR"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(1, m, "NVPT"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(2, m, "TACN"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(3, m, "AFB"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(4, m, "FUEL"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(5, m, "TNK"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(6, m, "MEZ"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(7, m, "DL"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(8, m, "FREQ"));
		m.Menus[MenuEnum.RDE].AddItem(SkItem.new(9, m, "COOP"));

		m.ActivatePage(PageEnum.PLN);
		m.ActivateMenu(MenuEnum.PRI);
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
			if(plnInUse == index+1) {
				TvTabInstances[index].ActivateMenu(4);
			}
			if(plnInUse == 0)
			{
				TvTabInstances[index].ActivatePage(PageEnum.PLN);
				TvTabInstances[index].ActivateMenu(MenuEnum.PRI);
				plnInUse = index+1;
			}
		}
		else if (input == 11) {
			TvTabInstances[index].ActivatePage(PageEnum.NAV);
			TvTabInstances[index].ActivateMenu(MenuEnum.NAV);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 12) {
			TvTabInstances[index].ActivatePage(3); #F
			TvTabInstances[index].ActivateMenu(3);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 17) {
			TvTabInstances[index].ActivatePage(3); #VAS
			TvTabInstances[index].ActivateMenu(3);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 18) {
			TvTabInstances[index].ActivatePage(PageEnum.RDR);
			TvTabInstances[index].ActivateMenu(MenuEnum.TWS);
			if(index+1 == plnInUse) plnInUse = 0;
		}
		else if (input == 14) {
			if (TvTabInstances[index].GetActiveMenu() != 1) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.CAK);
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 15) {
			if (TvTabInstances[index].GetActiveMenu() != 2) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.CLW);
			}
			else {
				TvTabInstances[index].ActivateMenu(bak);
			}
		}
		else if (input == 20) {
			if (TvTabInstances[index].GetActiveMenu() != 0) {
				bak = TvTabInstances[index].GetActiveMenu();
				TvTabInstances[index].ActivateMenu(MenuEnum.C09);
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
	tvTav1Canvas.addPlacement({"node": "EHDD1.screen"});
	tvTav2Canvas.addPlacement({"node": "EHDD2.screen"});
	append(TvTabInstances, TVTAB.new(tvTav1Canvas.createGroup(), 0));
	append(TvTabInstances, TVTAB.new(tvTav2Canvas.createGroup(), 0));
	removelistener(tvTabListener);
	tvTavBtClick(0, 10);
	tvTavBtClick(1, 11);
});
