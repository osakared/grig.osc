package grig.osc;

import haxe.io.Bytes;
import sys.net.Host;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

#if nodejs
import js.node.dgram.Socket;
import js.node.Dgram;
#end

/**
    Represents a connection to a udp socket and abstracts to platform-specific versions as needed
**/
class UdpSocket
{
    #if nodejs
    private var socket = Dgram.createSocket(Udp4);
    #else
    private var socket = new sys.net.UdpSocket();
    #end

    public function new()
    {
    }

    public function send(buffer:Bytes, offset:Int, length:Int, host:String, port:Int):Promise<Int>
    {
        #if nodejs
        return Future.async((callback) -> {
            socket.send(js.node.buffer.Buffer.hxFromBytes(buffer), offset, length, port, host, (err, len) -> {
                if (err != null) callback(Failure(new Error(err.message)));
                else callback(Success(len));
            });
        });
        #else
        try {
            var address = new sys.net.Address();
            var host = new sys.net.Host(host);
            address.host = host.ip;
            address.port = port;
            var len = socket.sendTo(buffer, 0, buffer.length, address);
            return Future.sync(Success(len));
        } catch (e:haxe.Exception) {
            return Future.sync(Failure(new Error(InternalError, e.message)));
        }
        #end
    }
}