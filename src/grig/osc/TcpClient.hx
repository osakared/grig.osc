package grig.osc;

#if nodejs
typedef TcpClient = grig.osc.js.node.TcpClient;
#elseif (target.sys) // because we won't have TcpSocket otherwise

import haxe.io.Bytes;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class TcpClient implements PacketSender implements PacketListener
{
    private var socket = new TcpSocket();
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
            var len = socket.readInt32();
            var bytes = socket.read(len);
            for (listener in listeners) {
                listener(bytes);
            }
        } catch (e) {
        }
    }

    public function connect(host:String, port:Int):Void
    {
        socket.connect(host, port);
        socket.bigEndian = true;
        loopRunner = new LoopRunner(listenerLoop);
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
                    socket.writeInt32(packet.length);
                    socket.write(packet);
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