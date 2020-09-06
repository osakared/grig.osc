package grig.osc.js.node; #if nodejs

import js.node.dgram.Socket;
import js.node.Dgram;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class UdpPacketSender implements grig.osc.PacketSender
{
    private var socket = Dgram.createSocket(Udp4);
    private var host:String;
    private var port:Int;

    public function new(host:String, port:Int)
    {
        this.host = host;
        this.port = port;
    }

    public function sendPacket(packet:haxe.io.Bytes):Promise<Int>
    {
        return Future.async((callback) -> {
            socket.send(js.node.buffer.Buffer.hxFromBytes(packet), 0, packet.length, port, host, (err, len) -> {
                if (err != null) callback(Failure(new Error(err.message)));
                else callback(Success(len));
            });
        });
    }

    public function close():Void
    {
    }
}

#end