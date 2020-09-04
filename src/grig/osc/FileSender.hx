package grig.osc;

import haxe.io.Bytes;
import sys.io.File;
import sys.io.FileOutput;

/**
    Useful for debugging, writes packets to a file
**/
class FileSender implements PacketSender
{
    private var output:FileOutput;

    public function new(path:String)
    {
        output = File.write(path);
    }

    public function sendPacket(packet:Bytes):Void
    {
        output.write(packet);
    }
}