package grig.osc;

#if nodejs
typedef TcpServer = grig.osc.js.node.TcpServer;
#elseif !js

import haxe.io.Bytes;
import sys.net.Host;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

/**
    Represents a connection to a tcp socket
**/
class TcpServer implements PacketListener implements PacketSender
{
    private var socket = new sys.net.Socket();
    private var loopRunners = new Array<LoopRunner>();
    private var deque = new Deque<Bytes>();
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();
    private var clients = new Array<sys.net.Socket>();

    public function new()
    {
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int, maxConnections:Int = 10):Void
    {
        var host = new Host(host);
        socket.bind(host, port);
        socket.listen(maxConnections);
        var socketRunner = new LoopRunner(socketLoop, null, () -> {
            socket.close();
        });
        var callbackRunner = new LoopRunner(callbackLoop);
        LoopRunner.startMultiple([socketRunner, callbackRunner]);
        loopRunners.push(socketRunner);
        loopRunners.push(callbackRunner);
    }

    private function socketLoop():Void
    {
        try {
            var socket = socket.accept();
            if (socket != null) {
                socket.output.bigEndian = true;
                socket.input.bigEndian = true;
                clients.push(socket);
            }
            for (client in clients) {
                var len = client.input.readInt32();
                var bytes = client.input.read(len);
                deque.push(bytes);
            }
        } catch (e) {
        }
    }

    private function callbackLoop():Void
    {
        var packet = this.deque.pop(false);
        if (packet != null) {
            for (listener in listeners) {
                listener(packet);
            }
        }
    }

    public function close():Void
    {
        for (loopRunner in loopRunners) {
            loopRunner.stop();
        }
        socket.close();
    }

    public function sendPacket(packet:haxe.io.Bytes):Promise<Int>
    {
        var error = '';
        for (client in clients) {
            try {
                client.output.writeInt32(packet.length);
                client.output.write(packet);
            } catch (e:haxe.Exception) {
                error += '${e.toString()}\n';
            }
        }
        if (error == '') return Future.sync(Success(packet.length + 4));
        return Future.sync(Failure(new Error(InternalError, error)));
    }
}

#end