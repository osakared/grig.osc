package grig.osc;

interface PacketSender
{
    public function sendPacket(packet:haxe.io.Bytes):tink.core.Promise<Int>;
}