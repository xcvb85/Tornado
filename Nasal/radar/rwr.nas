#AIRCRAFT_([a-zA-Z]*)
RWR = {
    new: func (_ident) {
        var rwr = {parents: [RWR]};

# Threat list ID:
        #REVISION: 2022/02/12
        rwr.AIRBORNE = 1;
        rwr.LONG     = 2;
        rwr.MEDIUM   = 3;
        rwr.SHORT    = 4;
        rwr.EW       = 5;
        rwr.AWACS    = 6;

        rwr.lookupType = {
        # OPRF fleet and related aircrafts:
                "f-14b":                    rwr.AIRBORNE,
                "F-14D":                    rwr.AIRBORNE,
                "F-15C":                    rwr.AIRBORNE,
                "F-15D":                    rwr.AIRBORNE,
                "F-16":                     rwr.AIRBORNE,
                "JA37-Viggen":              rwr.AIRBORNE,
                "AJ37-Viggen":              rwr.AIRBORNE,
                "AJS37-Viggen":             rwr.AIRBORNE,
                "JA37Di-Viggen":            rwr.AIRBORNE,
                "m2000-5":                  rwr.AIRBORNE,
                "m2000-5B":                 rwr.AIRBORNE,
                "MiG-21bis":                rwr.AIRBORNE,
                "MiG-21MF-75":              rwr.AIRBORNE,
                "MiG-29":                   rwr.AIRBORNE,
                "SU-27":                    rwr.AIRBORNE,
                "EC-137R":                  rwr.AWACS,
                "RC-137R":                  rwr.AWACS,
                "E-8R":                     rwr.AWACS,
                "EC-137D":                  rwr.AWACS,
                "gci":                      rwr.EW,
                "Blackbird-SR71A":          rwr.AIRBORNE,
                "Blackbird-SR71A-BigTail":  rwr.AIRBORNE,
                "Blackbird-SR71B":          rwr.AIRBORNE,
                "A-10":                     rwr.AIRBORNE,
                "A-10-model":               rwr.AIRBORNE,
                "Typhoon":                  rwr.AIRBORNE,
                "ZSU-23-4M":                rwr.SHORT,
                "S-75":                     rwr.MEDIUM,
                "buk-m2":                   rwr.MEDIUM,
                "s-300":                    rwr.MEDIUM,
                "MIM104D":                  rwr.MEDIUM,
                "missile_frigate":          rwr.LONG,
                "frigate":                  rwr.LONG,
                "fleet":                    rwr.LONG,
                "Mig-28":                   rwr.AIRBORNE,
                "Jaguar-GR1":               rwr.AIRBORNE,
        # Other threatening aircrafts (FGAddon, FGUK, etc.):
                "AI":                       rwr.AIRBORNE,
                "SU-37":                    rwr.AIRBORNE,
                "J-11A":                    rwr.AIRBORNE,
                "daVinci_SU-34":            rwr.AIRBORNE,
                "Su-34":                    rwr.AIRBORNE,
                "T-50":                     rwr.AIRBORNE,
                "MiG-21Bison":              rwr.AIRBORNE,
                "Mig-29":                   rwr.AIRBORNE,
                "EF2000":                   rwr.AIRBORNE,
                "F-15C_Eagle":              rwr.AIRBORNE,
                "F-15J_ADTW":               rwr.AIRBORNE,
                "F-15DJ_ADTW":              rwr.AIRBORNE,
                "f16":                      rwr.AIRBORNE,
                "F-16CJ":                   rwr.AIRBORNE,
                "FA-18C_Hornet":            rwr.AIRBORNE,
                "FA-18D_Hornet":            rwr.AIRBORNE,
                "f18":                      rwr.AIRBORNE,
                "F-111C":                   rwr.AIRBORNE,
                "A-10-modelB":              rwr.AIRBORNE,
                "Su-15":                    rwr.AIRBORNE,
                "jaguar":                   rwr.AIRBORNE,
                "Jaguar-GR3":               rwr.AIRBORNE,
                "E3B":                      rwr.AWACS,
                "E-2C-Hawkeye":             rwr.AWACS,
                "onox-awacs":               rwr.AWACS,
                "u-2s":                     rwr.AWACS,
                "U-2S-model":               rwr.AWACS,
                "F-4S":                     rwr.AIRBORNE,
                "F-4EJ_ADTW":               rwr.AIRBORNE,
                "FGR2-Phantom":             rwr.AIRBORNE,
                "F4J":                      rwr.AIRBORNE,
                "F-4D":                     rwr.AIRBORNE,
                "F-4E":                     rwr.AIRBORNE,
                "F-4N":                     rwr.AIRBORNE,
                "a4f":                      rwr.AIRBORNE,
                "A-4K":                     rwr.AIRBORNE,
                "F-5E":                     rwr.AIRBORNE,
                "F-5E-TigerII":             rwr.AIRBORNE,
                "F-5ENinja":                rwr.AIRBORNE,
                "f-20A":                    rwr.AIRBORNE,
                "f-20C":                    rwr.AIRBORNE,
                "f-20prototype":            rwr.AIRBORNE,
                "f-20bmw":                  rwr.AIRBORNE,
                "f-20-dutchdemo":           rwr.AIRBORNE,
                "Tornado-GR4a":             rwr.AIRBORNE,
                "Tornado-IDS":              rwr.AIRBORNE,
                "Tornado-F3":               rwr.AIRBORNE,
                "Tornado-ADV":              rwr.AIRBORNE,
                "brsq":                     rwr.AIRBORNE,
                "Harrier-GR1":              rwr.AIRBORNE,
                "Harrier-GR3":              rwr.AIRBORNE,
                "Harrier-GR5":              rwr.AIRBORNE,
                "Harrier-GR9":              rwr.AIRBORNE,
                "AV-8B":                    rwr.AIRBORNE,
                "G91-R1B":                  rwr.AIRBORNE,
                "G91":                      rwr.AIRBORNE,
                "g91":                      rwr.AIRBORNE,
                "mb339":                    rwr.AIRBORNE,
                "mb339pan":                 rwr.AIRBORNE,
                "alphajet":                 rwr.AIRBORNE,
                "MiG-15bis":                rwr.AIRBORNE,
                "MiG-23ML":                 rwr.AIRBORNE,
                "MiG-23MLD":                rwr.AIRBORNE,
                "Su-25":                    rwr.AIRBORNE,
                "MiG-25":                   rwr.AIRBORNE,
                "A-6E-model":               rwr.AIRBORNE,
                "A-6E":                     rwr.AIRBORNE,
                "F-117":                    rwr.AIRBORNE,
                "F-22-Raptor":              rwr.AIRBORNE,
                "F-35A":                    rwr.AIRBORNE,
                "F-35B":                    rwr.AIRBORNE,
                "F-35C":                    rwr.AIRBORNE,
                "daVinci_F-35A":            rwr.AIRBORNE,
                "daVinci_F-35B":            rwr.AIRBORNE,
                "JAS-39C_Gripen":           rwr.AIRBORNE,
                "gripen":                   rwr.AIRBORNE,
                "Yak-130":                  rwr.AIRBORNE,
                "L-159":                    rwr.AIRBORNE,
                "super-etendard":           rwr.AIRBORNE,
                "Mirage_F1-model":          rwr.AIRBORNE,
                "USS-NORMANDY":             rwr.LONG,
                "USS-LakeChamplain":        rwr.LONG,
                "USS-OliverPerry":          rwr.LONG,
                "USS-SanAntonio":           rwr.LONG,
                "mp-nimitz":                rwr.LONG,
                "mp-eisenhower":            rwr.LONG,
                "mp-vinson":                rwr.LONG,
                "mp-clemenceau":            rwr.LONG,
                "ufo":                      rwr.AIRBORNE,
                "bluebird-osg":             rwr.AIRBORNE,
                "Vostok-1":                 rwr.AIRBORNE,
                "V-1":                      rwr.AIRBORNE,
                "SpaceShuttle":             rwr.AIRBORNE,
                "F-23C_BlackWidow-II":      rwr.AIRBORNE,
        };
        rwr.shownList = [];
        #
        # recipient that will be registered on the global transmitter and connect this
        # subsystem to allow subsystem notifications to be received
        rwr.recipient = emesary.Recipient.new(_ident);
        rwr.recipient.parent_obj = rwr;
        rwr.vector_aicontacts = [];

        rwr.recipient.Receive = func(notification)
        {
            if (notification.NotificationType == "FrameNotification")
            {
                #printf("RWR-canvas recv: %s", notification.NotificationType);
                me.parent_obj.update();
                return emesary.Transmitter.ReceiptStatus_OK;
            }
            
            return emesary.Transmitter.ReceiptStatus_NotProcessed;
        };
        emesary.GlobalTransmitter.Register(rwr.recipient);

        return rwr;
    },
    update: func {
        print("rwr update");
        var list = radar_system.getRWRList();
        me.elapsed = getprop("sim/time/elapsed-sec");
        
        var sorter = func(a, b) {
            if(a[1] > b[1]){
                return -1; # A should before b in the returned vector
            }elsif(a[1] == b[1]){
                return 0; # A is equivalent to b 
            }else{
                return 1; # A should after b in the returned vector
            }
        }
        me.sortedlist = sort(list, sorter); #sort threat
        
        foreach(me.contact; me.sortedlist) {
            print("rwr: " ~ me.contact[0].get_Callsign() ~ " " ~ me.contact[0].getModel() ~ " " ~ me.contact[1]);
        }
    },
};

var rwr = nil;

var rwrListener = setlistener("sim/signals/fdm-initialized", func () {
    rwr = RWR.new("RWR");
    timer = maketimer(0.5, func rwr.update());
    #timer.start();
    removelistener(rwrListener);
});

