package grig.osc.cs; #if cs

import cs.system.net.IPEndPoint;
import cs.system.net.sockets.UdpClient;
import haxe.io.Bytes;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class UdpPacketSender implements grig.osc.PacketSender
{
    private var socket:UdpClient;
    private var workerRunner = new grig.osc.WorkerRunner();

    public function new(host:String, port:Int)
    {
        socket = new UdpClient(host, port);
        workerRunner.start();
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
                    socket.Send(packet.getData(), packet.length);
                    callback(Success(packet.length));
                } catch (e:cs.system.Exception) {
                    callback(Failure(new Error(InternalError, '$e')));
                }
            });
        });
    }

    public function close()
    {
        workerRunner.stop();
        socket.Close();
    }
}

#end