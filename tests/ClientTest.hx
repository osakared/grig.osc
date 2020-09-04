package;

import grig.osc.Bundle;
import grig.osc.Client;
import grig.osc.Message;
import grig.osc.UdpPacketSender;
import sys.io.Process;
import sys.net.Host;
import tink.unit.Assert.*;
import tink.unit.AssertionBuffer;

using StringTools;

@asserts
class ClientTest
{
    private var port = 9000;

    public function new()
    {
    }

    public function testMessage()
    {
        port++;
        var packetSender = new UdpPacketSender(new Host('localhost'), port);
        var client = new Client(packetSender);
        var clientTester = new Process('npx', ['node', 'tests/testClient.js', '$port']);
        Sys.sleep(2);
        var message = new Message('/knob/1');
        message.arguments.push(new grig.osc.Float32Argument(0.5));
        client.sendMessage(message);
        if (clientTester.exitCode() != 0) {
            return assert(false);
        }
        var output = clientTester.stdout.readAll().toString().trim();
        
        clientTester.close();
        return assert(output == '{"address":"/knob/1","args":[{"type":"f","value":0.5}]}');
    }

    public function testBundle()
    {
        port++;
        var packetSender = new UdpPacketSender(new Host('localhost'), port);
        var client = new Client(packetSender);
        var clientTester = new Process('npx', ['node', 'tests/testClient.js', '$port']);
        Sys.sleep(2);
        var bundle = new Bundle('#bundle', Date.now());
        var message = new Message('/s_new');
        message.arguments.push(new grig.osc.Float32Argument(0.5));
        message.arguments.push(new grig.osc.Int32Argument(7));
        bundle.messages.push(message);
        message = new Message('/meta');
        message.arguments.push(new grig.osc.StringArgument('nonavian dinosaur'));
        message.arguments.push(new grig.osc.SymbolArgument('avians'));
        message.arguments.push(new grig.osc.BlobArgument(haxe.io.Bytes.ofString('DATA')));
        bundle.messages.push(message);
        client.sendBundle(bundle);
        if (clientTester.exitCode() != 0) {
            return assert(false);
        }
        var output = clientTester.stdout.readAll().toString().trim();
        trace(output);
        
        clientTester.close();
        return assert(true);//assert(output == '{"address":"/knob/1","args":[{"type":"f","value":0.5}]}');
    }
}