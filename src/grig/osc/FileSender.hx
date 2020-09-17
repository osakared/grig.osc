package grig.osc; #if (target.sys)

import haxe.io.Bytes;
import sys.io.File;
import sys.io.FileOutput;
import tink.core.Future;
import tink.core.Outcome;
import tink.core.Promise;

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

    public function sendPacket(packet:Bytes):Promise<Int>
    {
        output.write(packet);
        return Future.sync(Success(packet.length));
    }
}

#end