package grig.osc;

#if nodejs
typedef TcpClient = grig.osc.js.node.TcpClient;
#else

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import sys.net.Socket;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class TcpClient implements PacketSender implements PacketListener
{
    private var socket = new sys.net.Socket();
    private var address = new Address();
    private var workerRunner = new WorkerRunner();
    private var loopRunner:LoopRunner;
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();

    public function new()
    {
        workerRunner.start();
    }

    private function listenerLoop():Void
    {
        try {
            var len = socket.input.readInt32();
            var bytes = socket.input.read(len);
            for (listener in listeners) {
                listener(bytes);
            }
        } catch (e) {
        }
    }

    public function connect(host:String, port:Int):Void
    {
        socket.connect(new Host(host), port);
        socket.output.bigEndian = true;
        socket.input.bigEndian = true;
        loopRunner = new LoopRunner(listenerLoop);
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
                    socket.output.writeInt32(packet.length);
                    socket.output.write(packet);
                    callback(Success(packet.length + 4));
                } catch (e:haxe.Exception) {
                    callback(Failure(new Error(InternalError, e.message)));
                }
            });
        });
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function close()
    {
        socket.close();
        workerRunner.stop();
        if (loopRunner != null) loopRunner.stop();
    }
}

#end