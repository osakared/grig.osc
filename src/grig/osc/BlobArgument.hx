package grig.osc;

import haxe.io.Bytes;

class BlobArgument extends Argument
{
    public var blob(default, null):Bytes;

    public function new(blob:Bytes)
    {
        super(ArgumentType.Blob);
        this.blob = blob;
    }

    override private function get_value():String
    {
        return 'blob: ${blob.length}';
    }
}