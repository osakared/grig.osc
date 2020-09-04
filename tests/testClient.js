var osc = require("osc");

if (process.argv.length < 3) {
    console.log('Usage: node testClient.js PORT_NUMBER');
    process.exit(1);
}

port = parseInt(process.argv[2])

if (isNaN(port)) {
    console.log('Invalid number');
    process.exit(2);
}

var udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: port,
    metadata: true
});

// Listen for incoming OSC messages.
udpPort.on("message", function (oscMsg, timeTag, info) {
    console.log(JSON.stringify(oscMsg));
    process.exit(0);
});

udpPort.on("bundle", function (oscBundle, timeTag, info) {
    console.log(JSON.stringify(oscBundle));
    process.exit(0);
});

setTimeout(() => {
    // Abort so as not to freeze the script and let it fail
    process.exit(3);
}, 10000);

// Open the socket.
udpPort.open();
