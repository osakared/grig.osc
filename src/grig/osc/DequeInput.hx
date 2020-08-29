package grig.osc;

import haxe.io.Bytes;
import haxe.io.Input;
import sys.thread.Deque;

class DequeInput extends Input
{
    private var deque:Deque<Bytes>;
    private var bytes:Bytes = null;
    private var posInBytes:Int = 0;

    public function new(deque:Deque<Bytes>)
    {
        this.deque = deque;
    }

    private function refill()
    {
        bytes = deque.pop(true);
        posInBytes = 0;
    }

    override public function readByte():Int
    {
        if (bytes == null) refill();
        var b = bytes.get(posInBytes);
        posInBytes++;
        if (posInBytes == bytes.length) bytes = null;
        return b;
    }

    private function getAvailable():Int
    {
        if (bytes == null) return 0;
        return bytes.length - posInBytes;
    }

    override public function readBytes(buf:Bytes, pos:Int, len:Int):Int
    {
        if (bytes == null) refill();
        var available = getAvailable();
        var minLen = if (len > available) available else len;
        buf.blit(pos, bytes, posInBytes, minLen);
        posInBytes += minLen;
        if (posInBytes == bytes.length) bytes = null;
        return minLen;
    }
}