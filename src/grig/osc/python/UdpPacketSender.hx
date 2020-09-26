package grig.osc.python; #if python

import haxe.io.Bytes;
import python.Tuple;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class UdpPacketSender implements grig.osc.PacketSender
{
    private var socket = new Socket(python.lib.Socket.AF_INET, python.lib.Socket.SOCK_DGRAM);
    private var host:String;
    private var port:Int;
    private var workerRunner = new grig.osc.WorkerRunner();

    public function new(host:String, port:Int)
    {
        this.host = host;
        this.port = port;
        workerRunner.start();
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
                    socket.sendto(cast packet.getData(), Tuple2.make(host, port));
                    callback(Success(packet.length));
                } catch (e:haxe.Exception) {
                    callback(Failure(new Error(InternalError, e.message)));
                }
            });
        });
    }

    public function close()
    {
        workerRunner.stop();
    }
}

#end