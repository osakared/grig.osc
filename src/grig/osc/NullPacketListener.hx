package grig.osc;

/**
    A do-nothing packet listener for testing
**/
class NullPacketListener implements PacketListener
{
    public function new()
    {
    }

    public function registerCallback(listener:(packet:haxe.io.Bytes)->Void):Void
    {
    }
}