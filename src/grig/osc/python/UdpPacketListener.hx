package grig.osc.python; #if python

import haxe.io.Bytes;
import python.Tuple;

class UdpPacketListener implements grig.osc.PacketListener
{
    private var socket = new Socket(python.lib.Socket.AF_INET, python.lib.Socket.SOCK_DGRAM);
    private var loopRunners = new Array<grig.osc.LoopRunner>();
    private var deque = new grig.osc.Deque<Bytes>();
    private var listeners = new Array<(packet:Bytes)->Void>();
    private inline static var BYTES_LENGTH = 2048;

    public function new()
    {
    }

    public function registerCallback(listener:(packet:Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int):Void
    {
        socket.bind(Tuple2.make(host, port));
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
        var bytesAndAddress = socket.recvfrom(BYTES_LENGTH);
        deque.push(Bytes.ofData(bytesAndAddress._1));
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