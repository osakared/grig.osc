package grig.osc;

import haxe.io.Bytes;
import haxe.io.Input;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;
import sys.thread.Deque;
import sys.thread.Thread;

class UdpListener
{
    public var receiver(get, never):PacketReceiver;
    private var dequeReceiver:DequeReceiver;
    private var deque = new Deque<Bytes>();
    private var socket = new UdpSocket();
    private inline static var BYTES_LENGTH = 2048;

    private function get_receiver():PacketReceiver
    {
        return dequeReceiver;
    }

    public function new()
    {
        dequeReceiver = new DequeReceiver(deque);
    }

    public function bind(host:Host, port:Int):Void
    {
        socket.bind(host, port);
        Thread.create(() -> {
            var senderAddress = new Address();
            var bytes = Bytes.alloc(BYTES_LENGTH);
            while (true) {
                socket.waitForRead();
                var length = socket.readFrom(bytes, 0, BYTES_LENGTH, senderAddress);
                deque.add(bytes.sub(0, length));
            }
        });
    }
}