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

class TcpClient implements grig.osc.PacketSender
{
    private var socket = new Socket();

    public function new()
    {
    }

    public function connect(host:String, port:Int):Void
    {
        socket.connect(port, host);
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