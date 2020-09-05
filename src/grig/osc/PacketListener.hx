package grig.osc;

interface PacketListener
{
    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void;
}