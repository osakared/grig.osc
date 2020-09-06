package grig.osc.js.node; #if nodejs

import haxe.io.Bytes;
import js.node.buffer.Buffer;
import js.node.Net;
import js.node.net.Server;
import js.node.net.Socket;
import tink.core.Error;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

using grig.osc.BytesTypes;

class TcpServer implements grig.osc.PacketListener implements grig.osc.PacketSender
{
    private var socket:Server;
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();
    private var clients = new Array<Socket>();

    public function new()
    {
        socket = Net.createServer(onConnection);
    }

    private function onConnection(client:Socket):Void
    {
        client.on('data', onData);
        clients.push(client);
    }

    public function registerCallback(listener:(packet:Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int, maxConnections:Int = 10):Void
    {
        socket.listen(port, host);
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

    public function close():Void
    {
        socket.close();
    }

    public function sendPacket(packet:haxe.io.Bytes):tink.core.Promise<Int>
    {
        var buffer = Buffer.hxFromBytes(packet);
        for (client in clients) {
            client.write(buffer);
        }
        return Future.sync(Success(packet.length + 4));
    }
}

#end