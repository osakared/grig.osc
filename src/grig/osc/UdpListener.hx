package grig.osc; #if (cpp || hl || neko)

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;

class UdpListener
{
    public var receiver(get, never):PacketReceiver;
    private var dequeReceiver:DequeReceiver;
    private var deque = new Deque<Bytes>();
    private var socket = new UdpSocket();
    private var running:Bool = false;
    private inline static var BYTES_LENGTH = 2048;
    private var bytes = Bytes.alloc(BYTES_LENGTH);

    private function get_receiver():PacketReceiver
    {
        return dequeReceiver;
    }

    public function new()
    {
        dequeReceiver = new DequeReceiver(deque);
    }

    /**
     * Start listening on `host` and `port` on a new thread
     * @param host 
     * @param port 
     */
    public function bind(host:Host, port:Int):Void
    {
        socket.bind(host, port);
        running = true;
        Thread.create(thread);
    }

    private function thread():Void
    {
        var senderAddress = new Address();
        while (running) {
            socket.waitForRead();
            var length = socket.readFrom(bytes, 0, BYTES_LENGTH, senderAddress);
            deque.push(bytes.sub(0, length));
        }
    }

    /**
     * Close socket and stop thread
     */
    public function close():Void
    {
        running = false;
        // Should wait first?
        socket.close();
    }
}

#end