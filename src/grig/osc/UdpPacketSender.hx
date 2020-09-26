package grig.osc;

#if nodejs
typedef UdpPacketSender = grig.osc.js.node.UdpPacketSender;
#elseif python
typedef UdpPacketSender = grig.osc.python.UdpPacketSender;
#elseif java
typedef UdpPacketSender = grig.osc.java.UdpPacketSender;
#elseif (target.sys)

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
    private var workerRunner = new WorkerRunner();

    public function new(host:String, port:Int)
    {
        var host = new Host(host);
        address.host = host.ip;
        address.port = port;
        workerRunner.start();
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
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