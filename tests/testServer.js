var osc = require("osc");
var Long = require("long");

var udpPort = new osc.UDPPort({
    remoteAddress: "127.0.0.1",
    remotePort: 8000
});

udpPort.open();

udpPort.on("ready", function() {
    udpPort.send({
        address: "/s_new",
        args: [
            {
                type: "s",
                value: "default"
            },
            {
                type: "t",
                value: osc.timeTag(0, 1598719746396)
            },
            {
                type: "h",
                value: new Long(0xFFFFFFFF, 0x7FFFFFFF)
            }
        ]
    });
    udpPort.send({
        //timeTag: osc.timeTag(60),
	    timeTag: osc.timeTag(0),

        packets: [
            {
                address: "/carrier/frequency",
                args: [
                    {
                        type: "f",
                        value: 440
                    }
                ]
            },
            {
                address: "/carrier/amplitude",
                args: [
                    {
                        type: "f",
                        value: 0.5
                    }
                ]
            },
            {
                address: "/algorithm",
                args: [
                    {
                        type: "i",
                        value: 7
                    }
                ]
            }
        ]
    });

    // Ideally it would wait exactly until the above functions finished but doesn't seem to be avail
    setTimeout(() => udpPort.close(), 1000);
});
