package;

import grig.osc.ArgumentType;
import grig.osc.Bundle;
import grig.osc.Message;
import grig.osc.Server;
import grig.osc.UdpListener;
import sys.net.Host;
import tink.unit.Assert.*;
import tink.unit.AssertionBuffer;

@:asserts
class ServerTest {

    private static var serverTestValues = [
        {
            address: '/s_new',
            arguments: [
                's default',
                't 2020-09-01 22:19:42',
                'h 9223372036854775807',
                'd 0.5',
                'S symbol',
                'c B',
                'r 0xFF0000FF', // 0xff0000ff
                'm 0x91240D00', // 0x91240d00
                'T true',
                'F false',
                'N null',
                'I inf',
                '[ [f 1.5,i 1]'
            ],
            messages: []
        },
        {
            address: '#bundle',
            arguments: [],
            messages: [
                {
                    address: '/carrier/frequency',
                    arguments: [ 'f 440' ]
                },
                {
                    address: '/carrier/amplitude',
                    arguments: [ 'f 0.5' ]
                },
                {
                    address: '/algorithm',
                    arguments: [ 'i 7' ]
                }
            ]
        }
    ];

    public function new()
    {
    }

    public function testUDP()
    {
        // Ensure this is skipped for platforms udp doesn't work
        var asserts = new AssertionBuffer();
        var listener = new UdpListener();
        listener.bind(new Host('0.0.0.0'), 8000);
        var server = new Server(listener.receiver);
        var i = 0;
        server.setCallback((packet) -> {
            var testValues = serverTestValues[i++];
            asserts.assert(testValues.address == packet.address);
            if (testValues.arguments.length > 0) {
                asserts.assert(Std.is(packet, Message));
                var message:Message = cast packet;
                asserts.assert(testValues.messages.length == 0);
                asserts.assert(testValues.arguments.length == message.arguments.length);
                if (testValues.arguments.length != message.arguments.length) return;
                for (j in 0...testValues.arguments.length) {
                    asserts.assert(testValues.arguments[j] == message.arguments[j].toString());
                }
            } else if (testValues.messages.length > 0) {
                asserts.assert(Std.is(packet, Bundle));
                var bundle:Bundle = cast packet;
                asserts.assert(testValues.messages.length == bundle.messages.length);
                if (testValues.messages.length != bundle.messages.length) return;
                for (j in 0...testValues.messages.length) {
                    var testMessage = testValues.messages[j];
                    var message = bundle.messages[j];
                    asserts.assert(testMessage.address == message.address);
                    asserts.assert(testMessage.arguments.length == message.arguments.length);
                    if (testMessage.arguments.length != message.arguments.length) return;
                    for (k in 0...testMessage.arguments.length) {
                        asserts.assert(testMessage.arguments[k] == message.arguments[k].toString());
                    }
                }
            }
        });
        server.start();
        Sys.command('node tests/testServer.js');
        return asserts.done();
    }

}
