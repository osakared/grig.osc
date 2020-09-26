package grig.osc.java; #if java

import haxe.io.Bytes;
import java.net.InetAddress;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.NativeArray;
import java.StdTypes;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class UdpPacketSender implements grig.osc.PacketSender
{
    private var socket:DatagramSocket;
    private var workerRunner = new grig.osc.WorkerRunner();
    private var address:InetAddress;
    private var port:Int;

    public function new(host:String, port:Int)
    {
        address = InetAddress.getByName(host);
        socket = new DatagramSocket();
        this.port = port;
        workerRunner.start();
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            workerRunner.queue(() -> {
                try {
                    var datagramPacket = new DatagramPacket(packet.getData(), packet.length, address, port);
                    socket.send(datagramPacket);
                    callback(Success(packet.length));
                } catch (e:java.lang.Exception) {
                    callback(Failure(new Error(InternalError, '$e')));
                }
            });
        });
    }

    public function close()
    {
        workerRunner.stop();
        socket.close();
    }
}

#end