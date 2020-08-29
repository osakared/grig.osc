package grig.osc;

import haxe.io.Bytes;
import sys.thread.Deque;

class DequeReceiver implements PacketReceiver
{
    private var deque:Deque<Bytes>;
    private var bytes:Bytes = null;
    private var posInBytes:Int = 0;

    public function new(deque:Deque<Bytes>)
    {
        this.deque = deque;
    }

    public function getPacket():Bytes
    {
        return this.deque.pop(true);
    }
}