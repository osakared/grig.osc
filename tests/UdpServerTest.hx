package;

import grig.osc.argument.ArgumentType;
import grig.osc.Bundle;
import grig.osc.Message;
import grig.osc.Server;
import grig.osc.UdpPacketListener;
import sys.net.Host;
import tink.core.Future;
import tink.unit.Assert.*;
import tink.unit.AssertionBuffer;

@:asserts
class UdpServerTest
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

    @:describe("Test registering and deregistering callbacks with the server")
    public function testRegister()
    {
        var socket = new grig.osc.NullPacketListener();
        var server = new Server(socket);
        asserts.assert(server.numCallbacks == 0);
        server.registerCallback((message) -> {}, '/fader/1');
        asserts.assert(server.numCallbacks == 1);
        server.registerCallback((message) -> {}, '/fader/2');
        asserts.assert(server.numCallbacks == 2);
        server.deregisterCallbacks('/fader/1');
        asserts.assert(server.numCallbacks == 1);
        server.deregisterAllCallbacks();
        asserts.assert(server.numCallbacks == 0);
        return asserts.done();
    }

    #if (cpp || hl || neko || nodejs || java || cs)
    @:timeout(10000)
    @:describe("Tests using grig's udp client and udp server")
    public function testClientAndServer()
    {
        return Future.async((callback) -> {
            // Ensure this is skipped for platforms udp doesn't work
            port++;
            var socket = new UdpPacketListener();
            var server = new Server(socket);
            server.registerFloat32Callback((val) -> {
                socket.close();
                callback(assert(val == 0.5));
            }, '/knob/1');
            socket.bind('0.0.0.0', port);
            var packetSender = new grig.osc.UdpPacketSender('localhost', port);
            var client = new grig.osc.Client(packetSender);
            var message = new Message('/knob/1');
            message.arguments.push(new grig.osc.argument.Float32Argument(0.5));
            client.sendMessage(message);
        });
    }
    #end

    #if (cpp || hl || neko || java || cs)
    public function testFilter()
    {
        // Ensure this is skipped for platforms udp doesn't work
        port++;
        var socket = new UdpPacketListener();
        var server = new Server(socket);
        var messageCount = 0;
        server.registerCallback((message) -> {
            messageCount++;
        }, '^/carrier/.*$', true, [ArgumentType.Float32]);
        socket.bind('0.0.0.0', port);
        Sys.command('node tests/testServer.js $port');
        socket.close();
        return assert(messageCount == 2);
    }

    @:describe("Test udp server with external udp client")
    public function testUDP()
    {
        // Ensure this is skipped for platforms udp doesn't work
        port++;
        var socket = new UdpPacketListener();
        socket.bind('0.0.0.0', port);
        var server = new Server(socket);
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
        Sys.command('node tests/testServer.js $port');
        socket.close();
        return asserts.done();
    }
    #end

}
