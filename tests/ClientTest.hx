package;

import grig.osc.Client;
import grig.osc.Float32Argument;
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

    public function testRegister()
    {
        port++;
        var packetSender = new UdpPacketSender(new Host('localhost'), port);
        var client = new Client(packetSender);
        var clientTester = new Process('npx', ['node', 'tests/testClient.js', '$port']);
        Sys.sleep(2);
        var message = new Message('/knob/1');
        message.arguments.push(new Float32Argument(0.5));
        client.sendMessage(message);
        if (clientTester.exitCode() != 0) {
            return assert(false);
        }
        var output = clientTester.stdout.readAll().toString().trim();
        
        clientTester.close();
        return assert(output == '{"address":"/knob/1","args":[{"type":"f","value":0.5}]}');
    }
}