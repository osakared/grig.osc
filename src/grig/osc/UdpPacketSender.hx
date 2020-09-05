package grig.osc;

import haxe.io.Bytes;
import sys.net.Address;

class UdpPacketSender implements PacketSender
{
    private var socket = new UdpSocket();
    private var address = new Address();
    private var host:String;
    private var port:Int;

    public function new(host:String, port:Int)
    {
        this.host = host;
        this.port = port;
    }

    public function sendPacket(packet:Bytes):Void
    {
        socket.send(packet, 0, packet.length, host, port);
    }
}