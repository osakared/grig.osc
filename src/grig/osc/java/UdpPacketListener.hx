package grig.osc.java; #if java

import haxe.io.Bytes;
import java.net.DatagramPacket;
import java.NativeArray;
import java.StdTypes;

class UdpPacketListener implements grig.osc.PacketListener
{
    private var socket = new java.net.DatagramSocket();
    private var loopRunners = new Array<LoopRunner>();
    private var deque = new Deque<Bytes>();
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();
    private inline static var BYTES_LENGTH = 2048;
    private var bytes = new NativeArray<Int8>(BYTES_LENGTH);

    public function new()
    {
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int):Void
    {
        var address = new java.net.InetSocketAddress(host, port);
        socket.bind(address);
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
        var packet = new DatagramPacket(bytes, bytes.length);
        socket.receive(packet);
        var length = packet.getLength();
        var newBytes = Bytes.ofData(bytes);
        deque.push(newBytes.sub(0, length));
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