package grig.osc.js.node; #if nodejs

import js.node.buffer.Buffer;
import js.node.dgram.Socket;
import js.node.Dgram;

class UdpPacketListener implements grig.osc.PacketListener
{
    private var socket = Dgram.createSocket(Udp4);
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();

    public function new()
    {
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int):Void
    {
        socket.bind(port, host);
        socket.addListener('message', dispatchPacket);
    }

    private function dispatchPacket(buffer:Buffer):Void
    {
        for (listener in listeners) {
            listener(buffer.hxToBytes());
        }
    }

    public function close():Void
    {
        socket.close();
    }
}

#end