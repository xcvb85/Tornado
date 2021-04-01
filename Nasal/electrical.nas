##########################################################################################################
# Electrical Systems (battery class based on battery class from tu154b)
# Daniel Overbeck - 2017
##########################################################################################################

# global definces
var ELNode = "systems/electrical/";
var Refresh = 0.05;

##########################################################################################################
var APU = {
    new: func(name, source, refVoltage) {
        obj = { parents: [APU],
            Connected: props.globals.initNode(ELNode ~ name ~ "/Connected", 0, "BOOL"),
            Current: props.globals.initNode(ELNode ~ name ~ "/Current", 0, "DOUBLE"), #A
            Voltage: props.globals.initNode(ELNode ~ name ~ "/Voltage", 0, "DOUBLE"), #V
            IndicatorGenerator: props.globals.initNode(ELNode ~ name ~ "/IndicatorGenerator", 0, "INT"),
            IndicatorMaster: props.globals.initNode(ELNode ~ name ~ "/IndicatorMaster", 0, "INT"),
            IndicatorStart: props.globals.initNode(ELNode ~ name ~ "/IndicatorStart", 0, "INT"),
            Source: props.globals.getNode(source, 1),
            Running: 0,
            RefVoltage: refVoltage, #V
            Tmp: 0
        };
        return obj;
    },
    getCurrent: func {
        if(!me.Connected.getValue() or !me.Running) {
            return 0;
        }
        return -1; #negative value -> producer
    },
    getVoltage: func {
        me.Tmp = 0;

        if(me.Running) {
            me.Voltage.setValue(me.RefVoltage);

            if(me.Connected.getValue()) {
                me.Tmp = me.RefVoltage;
            }
        }
        else {
            me.Voltage.setValue(0);
        }
        return me.Tmp;
    },
    setConnected: func(connected) {
        me.Connected.setValue(connected);
    },
    setCurrent: func(current) {
        me.Running = me.Source.getValue() or 0;

        # generator
        if(me.Running) {
            if(me.Connected.getValue()) {
                # on
                me.IndicatorGenerator.setValue(1);
                me.Current.setValue(current);
            }
            else {
                # avail
                me.IndicatorGenerator.setValue(11);
                me.Current.setValue(0);
            }
        }
        else {
            # black
            me.IndicatorGenerator.setValue(0);
            me.Current.setValue(0);
        }

        # master and start
        if(getprop("systems/electrical/APU/btnMaster")) {
            # master on
            me.IndicatorMaster.setValue(1);

            if(me.Running) {
                # starter ready
                me.IndicatorStart.setValue(1);
            }
            else {
                if(getprop("controls/engines/engine[2]/starter")) {
                    # starter black
                    me.IndicatorStart.setValue(0);
                }
                else {
                    # starter start
                    me.IndicatorStart.setValue(3);
                }

                if(getprop("systems/electrical/APU/btnStart")) {
                    setprop("controls/engines/engine[2]/starter", 1);
                }
            }
        }
        else {
            # black
            me.IndicatorMaster.setValue(0);
            me.IndicatorStart.setValue(0);

            if(me.Running) {
                stop_apu();
            }
        }
    },
    setVoltage: func(volts) {
    }
};

##########################################################################################################
# From ATA 24.41: "Two identical nickel cadmium batteries (BAT) 24 V/40 Ah are installed in the aircraft."
var Battery = {
    new: func(name) {
        obj = { parents: [Battery],
            Connected: props.globals.initNode(ELNode ~ name ~ "/Connected", 0, "BOOL"),
            Current: props.globals.initNode(ELNode ~ name ~ "/Current", 0, "DOUBLE"), #A
            Voltage: props.globals.initNode(ELNode ~ name ~ "/Voltage", 24, "DOUBLE"), #V
            Indicator: props.globals.initNode(ELNode ~ name ~ "/Indicator", 0, "INT"),
            Running: 0,
            RefVoltage: 24, #V
            Capacity: 40, #Ah
            Charge: 1, #%
            DCharge: 0,
            Tmp: 0
        };
        return obj;
    },
    getCurrent: func {
        if(!me.Connected.getValue() or !me.Running) {
            return 0;
        }
        return -1; #negative value -> producer
    },
    getVoltage: func {
        if(!me.Connected.getValue()) {
            return 0;
        }
        return me.Voltage.getValue();
    },
    setConnected: func(connected) {
        me.Connected.setValue(connected);
    },
    setCurrent: func(current) {
        if(me.Connected.getValue() and me.Running) {
            me.Tmp = (current * Refresh) / 3600.0; # used amp hrs
            me.DCharge = me.Tmp / me.Capacity;
            me.Charge -= me.DCharge;

            if(me.Charge < 0.0) {
                me.Charge = 0.0;
            } elsif (me.Charge > 1.0) {
                me.Charge = 1.0;
            }
            me.Current.setValue(current);
        }
        else {
            me.Current.setValue(0);
        }
    },
    setVoltage: func(volts) {
        # deactivate if voltage smaller than external
        me.Tmp = (1.0 - me.Charge) / 10;

        if((volts-me.DCharge) > (me.RefVoltage - me.Tmp)) {
            me.Running = 0;
        }
        else {
            me.Running = 1;
        }
        me.Voltage.setValue(me.RefVoltage - me.Tmp);

        if(me.Connected.getValue()) {
            me.Indicator.setValue(0);
        }
        else {
            me.Indicator.setValue(0);
        }
    }
};

##########################################################################################################
var Bus = {
    new: func(name) {
        obj = { parents: [Bus],
            Devices: [],
            Voltage: props.globals.initNode(ELNode ~ "/" ~ name ~ "/Voltage", 0, "DOUBLE"),
            Current: props.globals.initNode(ELNode ~ "/" ~ name ~ "/Current", 0, "DOUBLE"),
            Device: 0,
            Max: 0,
            Tmp: 0,
            Producers: 0
        };
        return obj;
    },
    append: func(device) {
	append(me.Devices, device);
    },
    getCurrent: func {
        return me.Current.getValue();
    },
    getProducers: func {
        return me.Producers;
    },
    getVoltage: func {
        return me.Voltage.getValue();
    },
    setCurrent: func(current) {
        me.Current.setValue(current);
    },
    setProducers: func(producers) {
        me.Producers = producers;
    },
    setVoltage: func(voltage) {
        me.Voltage.setValue(voltage);
    },
    update: func {
        # values can be manipulated by bus tie
        me.updateCurrent();
        me.updateVoltage();
    },
    updateCurrent: func {
        # set old current
        me.Tmp = me.Current.getValue();

        foreach(me.Device; me.Devices) {
            if(me.Producers > 0) {
                me.Device.setCurrent(me.Tmp / me.Producers);
            }
            else {
                me.Device.setCurrent(0);
            }
        }

        # get new current
        me.Max = 0;
        me.Producers = 0;
        foreach(me.Device; me.Devices) {
            me.Tmp = me.Device.getCurrent();

            if(me.Tmp < 0) {
                me.Producers += 1; # Producer
            }
            else {
                me.Max += me.Tmp; # Consumer
            }
        }
        me.Current.setValue(me.Max);
    },
    updateVoltage: func {
        me.Max = 0;

        foreach(me.Device; me.Devices) {
            # set old voltage
            me.Device.setVoltage(me.Voltage.getValue());

            # get new voltage
            me.Tmp = me.Device.getVoltage();
            if(me.Tmp > me.Max) {
                me.Max = me.Tmp;
            }
        }
        me.Voltage.setValue(me.Max);
    }
};

##########################################################################################################
var Consumer = {
    new: func(name, current, minVoltage) {
        obj = { parents : [Consumer],
            Devices: [],
            Connected: props.globals.initNode("instrumentation/" ~ name ~ "/serviceable", 0, "INT"),
            Running: props.globals.initNode(ELNode ~ "outputs/" ~ name, 0, "DOUBLE"),
            Current: current,
            MinVoltage: minVoltage,
            Tmp: 0,
            i: 0
        };
        return obj;
    },
    append: func(device) {
        me.Tmp = size(me.Devices);
        setsize(me.Devices, me.Tmp+1);
        me.Devices[me.Tmp] = device;
    },
    getCurrent: func {
        if(me.Running.getValue() < 24 or !me.Connected.getValue()) {
            return 0;
        }

	me.Tmp = me.Current;
	for(me.i=0; me.i<size(me.Devices); me.i+=1) {
		me.Tmp += me.Devices[me.i].getCurrent();
	}
        return me.Tmp;
    },
    getVoltage: func {
        return 0;
    },
    setCurrent: func(current) {
    },
    setVoltage: func(voltage) {
        if(me.Connected.getValue()) {
            if(voltage < me.MinVoltage) {
                me.Running.setValue(0);
                for(me.i=0; me.i<size(me.Devices); me.i+=1) {
                    me.Devices[me.i].setVoltage(0);
                }
            }
            else {
                me.Running.setValue(24);
                for(me.i=0; me.i<size(me.Devices); me.i+=1) {
                    me.Devices[me.i].setVoltage(voltage);
                }
            }
        }
        else {
            me.Running.setValue(0);
            for(me.i=0; me.i<size(me.Devices); me.i+=1) {
                me.Devices[me.i].setVoltage(0);
            }
        }
    }
};

##########################################################################################################
# From ATA 24.25: "The starter/generator system, with each of its two starter/generators (S/G), provides a
# separate DC MAIN BUS with 28.5 VDC."
var Generator = {
    new: func(name, source, refVoltage) {
        obj = { parents: [Generator],
            Connected: props.globals.initNode(ELNode ~ name ~ "/Connected", 0, "BOOL"),
            Current: props.globals.initNode(ELNode ~ name ~ "/Current", 0, "DOUBLE"), #A
            Voltage: props.globals.initNode(ELNode ~ name ~ "/Voltage", 0, "DOUBLE"), #V
            Indicator: props.globals.initNode(ELNode ~ name ~ "/Indicator", 0, "INT"),
            Source: props.globals.getNode(source, 1),
            Running: 0,
            RefVoltage: refVoltage, #V
            Tmp: 0
        };
        return obj;
    },
    getCurrent: func {
        if(!me.Connected.getValue() or !me.Running) {
            return 0;
        }
        return -1; #negative value -> producer
    },
    getVoltage: func {
        me.Tmp = 0;

        me.Running = me.Source.getValue() or 0;

        if(me.Running) {
            me.Voltage.setValue(me.RefVoltage);

            if(me.Connected.getValue()) {
                me.Tmp = me.RefVoltage;
            }
        }
        else {
            me.Voltage.setValue(0);
        }
        return me.Tmp;
    },
    setConnected: func(connected) {
        me.Connected.setValue(connected);
    },
    setCurrent: func(current) {
        if(me.Connected.getValue()) {
            if(me.Running) {
                # black
                me.Indicator.setValue(0);
                me.Current.setValue(current);
            }
            else {
                # fail
                me.Indicator.setValue(12);
                me.Current.setValue(0);
            }
        }
        else {
            # off
            me.Indicator.setValue(1);
            me.Current.setValue(0);
        }
    },
    setVoltage: func(volts) {
    }
};


##########################################################################################################
# buses
var elBus = Bus.new("ElBus");

# producers
var battery = Battery.new("Battery");
var generator1 = Generator.new("Generator1", "/engines/engine[0]/running", 28.5);
var generator2 = Generator.new("Generator2", "/engines/engine[1]/running", 28.5);
#var apu = APU.new("APU", "/engines/engine[2]/running", 28.5);
var ehdd = Consumer.new("ehdd", 4, 18.1);
var tvtab1 = Consumer.new("tvtab1", 4, 17.9);
var tvtab2 = Consumer.new("tvtab2", 4, 18.0);
elBus.append(battery);
elBus.append(generator1);
elBus.append(generator2);
#elBus.append(apu);
elBus.append(ehdd);
elBus.append(tvtab1);
elBus.append(tvtab2);

# no separate switch
setprop("instrumentation/hud/serviceable", 1);

update_electrical = func {
    elBus.update();
}
var electrical_timer = maketimer(Refresh, update_electrical);
electrical_timer.start();
