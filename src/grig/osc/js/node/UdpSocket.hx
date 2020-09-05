package grig.osc.js.node; #if nodejs

import js.node.dgram.Socket;
import js.node.Dgram;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

class UdpSocket
{
    private var socket = Dgram.createSocket(Udp4);

    public function new()
    {
    }

    public function send(buffer:haxe.io.Bytes, offset:Int, length:Int, host:String, port:Int):Promise<Int>
    {
        return Future.async((callback) -> {
            socket.send(js.node.buffer.Buffer.hxFromBytes(buffer), offset, length, port, host, (err, len) -> {
                if (err != null) callback(Failure(new Error(err.message)));
                else callback(Success(len));
            });
        });
    }
}

#end