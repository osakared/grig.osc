package grig.osc;

import haxe.io.Bytes;
import sys.net.Address;
import sys.net.Host;
import sys.net.UdpSocket;

class UdpPacketSender implements PacketSender
{
    private var socket = new UdpSocket();
    private var address = new Address();

    public function new(host:Host, port:Int)
    {
        address.host = host.ip;
        address.port = port;
    }

    public function sendPacket(packet:Bytes):Void
    {
        socket.sendTo(packet, 0, packet.length, address);
    }
}