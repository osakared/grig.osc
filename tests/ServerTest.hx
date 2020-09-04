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
class ServerTest
{

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
                'r 0xFF0000FF',
                'm 0x91240D00',
                'T true',
                'F false',
                'N null',
                'I inf',
                '[ [f 1.5, i 1]'
            ]
        },
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
    ];

    private var port = 8000;

    public function new()
    {
    }

    public function testRegister()
    {
        var asserts = new AssertionBuffer();
        var listener = new UdpListener();
        listener.bind(new Host('0.0.0.0'), port++);
        var server = new Server(listener.receiver);
        asserts.assert(server.numCallbacks == 0);
        server.registerCallback((message) -> {}, '/fader/1');
        asserts.assert(server.numCallbacks == 1);
        server.registerCallback((message) -> {}, '/fader/2');
        asserts.assert(server.numCallbacks == 2);
        server.deregisterCallbacks('/fader/1');
        asserts.assert(server.numCallbacks == 1);
        server.deregisterAllCallbacks();
        asserts.assert(server.numCallbacks == 0);
        server.close();
        return asserts.done();
    }

    public function testFilter()
    {
        // Ensure this is skipped for platforms udp doesn't work
        var listener = new UdpListener();
        port++;
        listener.bind(new Host('0.0.0.0'), port);
        var server = new Server(listener.receiver);
        var messageCount = 0;
        server.registerCallback((message) -> {
            messageCount++;
        }, '^/carrier/.*$', true, [ArgumentType.Float32]);
        server.start();
        Sys.command('node tests/testServer.js $port');
        server.close();
        return assert(messageCount == 2);
    }

    public function testUDP()
    {
        // Ensure this is skipped for platforms udp doesn't work
        var asserts = new AssertionBuffer();
        var listener = new UdpListener();
        port++;
        listener.bind(new Host('0.0.0.0'), port);
        var server = new Server(listener.receiver);
        var i = 0;
        server.registerCallback((message) -> {
            var testValues = serverTestValues[i++];
            asserts.assert(testValues.address == message.address);
            asserts.assert(testValues.arguments.length == message.arguments.length);
            if (testValues.arguments.length != message.arguments.length) return;
            for (j in 0...testValues.arguments.length) {
                asserts.assert(testValues.arguments[j] == message.arguments[j].toString());
            }
        });
        server.start();
        Sys.command('node tests/testServer.js $port');
        server.close();
        return asserts.done();
    }

}
