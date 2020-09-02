var osc = require("osc");
var Long = require("long");

if (process.argv.length < 3) {
    console.log('Usage: node testServer.js PORT_NUMBER');
    process.exit(1);
}

port = parseInt(process.argv[2])

if (isNaN(port)) {
    console.log('Invalid number');
    process.exit(2);
}

var udpPort = new osc.UDPPort({
    remoteAddress: "127.0.0.1",
    remotePort: port
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
                value: osc.timeTag(0, 1599023982510)
            },
            {
                type: "h",
                value: new Long(0xFFFFFFFF, 0x7FFFFFFF)
            },
            {
                type: "d",
                value: 0.5
            },
            {
                type: "S",
                value: "symbol"
            },
            {
                type: "c",
                value: "B"
            },
            {
                type: "r",
                value: { r: 255, g: 0, b: 0, a: 1.0 }
            },
            {
                type: "m",
                value: [ 0x91, 0x24, 0x0d ]
            },
            {
                type: 'T',
                value: true
            },
            {
                type: 'F',
                value: false
            },
            {
                type: 'N',
                value: null
            },
            {
                type: 'I',
                value: 1.0
            },
            [
                {
                    type: 'f',
                    value: 1.5
                },
                {
                    type: 'i',
                    value: 1
                }
            ]
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
