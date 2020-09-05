package grig.osc;

#if nodejs
typedef UdpSocket = grig.osc.js.node.UdpSocket;
#else

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

/**
    Represents a connection to a udp socket and abstracts to platform-specific versions as needed
**/
class UdpSocket implements PacketListener
{
    private var socket = new sys.net.UdpSocket();
    private var loopRunners = new Array<LoopRunner>();
    private var deque = new Deque<Bytes>();
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();
    private inline static var BYTES_LENGTH = 2048;
    private var bytes:Bytes;

    public function new()
    {
    }

    public function send(buffer:haxe.io.Bytes, offset:Int, length:Int, host:String, port:Int):Promise<Int>
    {
        try {
            var address = new Address();
            var host = new Host(host);
            address.host = host.ip;
            address.port = port;
            var len = socket.sendTo(buffer, 0, buffer.length, address);
            return Future.sync(Success(len));
        } catch (e:haxe.Exception) {
            return Future.sync(Failure(new Error(InternalError, e.message)));
        }
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int):Void
    {
        var host = new Host(host);
        bytes = Bytes.alloc(BYTES_LENGTH);
        socket.bind(host, port);
        var socketRunner = new LoopRunner(socketLoop, null, () -> {
            socket.close();
        });
        var callbackRunner = new LoopRunner(callbackLoop);
        LoopRunner.startMultiple([socketRunner, callbackRunner]);
        loopRunners.push(socketRunner);
        loopRunners.push(callbackRunner);
    }

    private function socketLoop():Void
    {
        var senderAddress = new Address();
        socket.waitForRead();
        var length = socket.readFrom(bytes, 0, BYTES_LENGTH, senderAddress);
        deque.push(bytes.sub(0, length));
    }

    private function callbackLoop():Void
    {
        var packet = this.deque.pop(false);
        if (packet != null) {
            for (listener in listeners) {
                listener(packet);
            }
        }
    }

    public function close():Void
    {
        for (loopRunner in loopRunners) {
            loopRunner.stop();
        }
    }
}

#end