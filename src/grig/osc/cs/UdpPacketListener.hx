package grig.osc.cs; #if cs

import cs.system.net.IPEndPoint;
import cs.system.net.sockets.UdpClient;
import grig.osc.Deque;
import grig.osc.LoopRunner;
import haxe.io.Bytes;

class UdpPacketListener implements grig.osc.PacketListener
{
    private var loopRunners = new Array<LoopRunner>();
    private var deque = new Deque<Bytes>();
    private var listeners = new Array<(packet:haxe.io.Bytes)->Void>();
    private inline static var BYTES_LENGTH = 2048;
    private var socket:UdpClient;
    private var endpoint:IPEndPoint;

    public function new()
    {
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
        listeners.push(listener);
    }

    public function bind(host:String, port:Int):Void
    {
        socket = new UdpClient(port);
        endpoint = new IPEndPoint(cs.system.net.IPAddress.Any, port);
        var socketRunner = new LoopRunner(socketLoop, null, () -> {
            socket.Close();
        });
        var callbackRunner = new LoopRunner(callbackLoop);
        LoopRunner.startMultiple([socketRunner, callbackRunner]);
        loopRunners.push(socketRunner);
        loopRunners.push(callbackRunner);
    }

    private function socketLoop():Void
    {
        var packet = socket.Receive(endpoint);
        deque.push(Bytes.ofData(packet));
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