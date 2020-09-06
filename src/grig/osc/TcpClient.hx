package grig.osc;

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import sys.net.Socket;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class TcpClient implements PacketSender
{
    private var socket = new sys.net.Socket();
    private var address = new Address();
    private var workerRunner = new WorkerRunner();

    public function new()
    {
        workerRunner.start();
    }

    public function connect(host:String, port:Int):Void
    {
        socket.connect(new Host(host), port);
        socket.output.bigEndian = true;
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
                    socket.output.writeInt32(packet.length);
                    socket.output.write(packet);
                    callback(Success(packet.length + 2));
                } catch (e:haxe.Exception) {
                    callback(Failure(new Error(InternalError, e.message)));
                }
            });
        });
    }

    public function close()
    {
        socket.close();
        workerRunner.stop();
    }
}