package;

import grig.osc.argument.ArgumentType;
import grig.osc.Server;
import grig.osc.TcpClient;
import grig.osc.TcpServer;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;
import tink.unit.Assert.*;
import tink.unit.AssertionBuffer;

@:asserts
class TcpTest
{
    private var port = 8500;

    public function new()
    {
    }

    #if (cpp || hl || neko || cs || java)
    public function testClientAndServer()
    {
        return Future.async((callback) -> {
            // Ensure this is skipped for platforms udp doesn't work
            port++;
            var socket = new TcpServer();
            var server = new Server(socket);
            var packetSender = new TcpClient();
            server.registerFloat32Callback((val) -> {
                socket.close();
                callback(assert(val == 0.5));
            }, '/knob/1');
            socket.bind('127.0.0.1', port);
            packetSender.connect('localhost', port);
            var client = new grig.osc.Client(packetSender);
            var message = new grig.osc.Message('/knob/1');
            message.arguments.push(new grig.osc.argument.Float32Argument(0.5));
            client.sendMessage(message);
        });
    }
    #end
}