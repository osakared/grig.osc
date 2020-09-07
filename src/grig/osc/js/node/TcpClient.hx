package grig.osc.js.node; #if nodejs

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import js.node.buffer.Buffer;
import js.node.Net;
import js.node.net.Socket;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

using grig.osc.BytesTypes;

class TcpClient implements grig.osc.PacketSender implements grig.osc.PacketListener
{
    private var socket = new Socket();
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();

    public function new()
    {
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function connect(host:String, port:Int):Void
    {
        socket.connect(port, host);
    }

    private function onData(buffer:js.node.buffer.Buffer):Void
    {
        var bytes = buffer.hxToBytes();
        var len = bytes.getInt32BigEndian(0);
        if (bytes.length - 4 != len) {
            trace('Packet apparently not using in32[packet] tcp protocol: actual length = ${bytes.length}, length = $len');
            return;
        }
        bytes = bytes.sub(4, len);
        for (listener in listeners) {
            listener(bytes);
        }
    }

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        var output = new BytesOutput();
        output.bigEndian = true;
        output.writeInt32(packet.length);
        output.write(packet);
        var buffer = Buffer.hxFromBytes(output.getBytes());
        output.close();
        socket.write(buffer);
        return Future.sync(Success(packet.length + 4));
    }

    public function close()
    {
    }
}

#end