package grig.osc;

import haxe.io.Bytes;

class BlobArgument extends Argument
{
    public function new(blob:Bytes)
    {
        super(blob, ArgumentType.Blob);
    }
}