package;

import grig.osc.Bundle;
import grig.osc.Client;
import grig.osc.Message;
import grig.osc.UdpPacketSender;
import haxe.Json;
import sys.io.Process;
import sys.net.Host;
import tink.unit.Assert.*;
import tink.unit.AssertionBuffer;

using StringTools;

@:asserts
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
        var bundle = new Bundle('#bundle', Date.fromTime(1599023982500));
        var message = new Message('/s_new');
        message.arguments.push(new grig.osc.Float32Argument(0.5));
        message.arguments.push(new grig.osc.Int32Argument(7));
        message.arguments.push(new grig.osc.DoubleArgument(0.5));
        message.arguments.push(new grig.osc.Int64Argument(5000));
        message.arguments.push(new grig.osc.TimeArgument(Date.fromTime(1599023982510)));
        bundle.messages.push(message);
        message = new Message('/meta');
        message.arguments.push(new grig.osc.StringArgument('nonavian dinosaur'));
        message.arguments.push(new grig.osc.SymbolArgument('avians'));
        message.arguments.push(new grig.osc.BlobArgument(haxe.io.Bytes.ofString('DATA')));
        message.arguments.push(new grig.osc.ColorArgument(0x0000ffff));
        message.arguments.push(new grig.osc.InfinitumArgument());
        bundle.messages.push(message);
        message = new Message('/buttons');
        message.arguments.push(new grig.osc.BooleanArgument(true));
        message.arguments.push(new grig.osc.BooleanArgument(false));
        message.arguments.push(new grig.osc.NilArgument());
        message.arguments.push(new grig.osc.CharArgument('B'));
        bundle.messages.push(message);
        message = new Message('/midi/1');
        message.arguments.push(new grig.osc.MidiArgument(0x91240D00));
        bundle.messages.push(message);
        client.sendBundle(bundle);
        if (clientTester.exitCode() != 0) {
            asserts.assert(false);
            return asserts.done();
        }
        var output:Array<Dynamic> = Json.parse(clientTester.stdout.readAll().toString()).packets;
        var outputCheck:Array<Dynamic> = Json.parse(haxe.Resource.getString('bundleCheck.json')).packets;

        asserts.assert(output[0].address == outputCheck[0].address);
        var args:Array<Dynamic> = output[0].args;
        var argsCheck:Array<Dynamic> = outputCheck[0].args;
        asserts.assert(args[0].type == argsCheck[0].type);
        asserts.assert(args[0].value == argsCheck[0].value);
        asserts.assert(args[1].type == argsCheck[1].type);
        asserts.assert(args[1].value == argsCheck[1].value);
        args = output[1].args;
        argsCheck = outputCheck[1].args;
        asserts.assert(args[0].type == argsCheck[0].type);
        asserts.assert(args[0].value == argsCheck[0].value);
        
        clientTester.close();
        return asserts.done();//Json.stringify(output.packets) == Json.stringify(outputCheck));
    }
}