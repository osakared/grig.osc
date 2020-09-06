package grig.osc;

#if nodejs
typedef UdpPacketSender = grig.osc.js.node.UdpPacketSender;
#else

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class UdpPacketSender implements PacketSender
{
    private var socket = new sys.net.UdpSocket();
    private var address = new Address();
    private var host:String;
    private var port:Int;
    private var workerRunner = new WorkerRunner();

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
                    var address = new Address();
                    var host = new Host(host);
                    address.host = host.ip;
                    address.port = port;
                    var len = socket.sendTo(packet, 0, packet.length, address);
                    callback(Success(len));
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