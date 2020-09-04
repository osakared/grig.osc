package grig.osc;

import haxe.io.Bytes;

using grig.osc.OutputTypes;

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

    override public function write(output:haxe.io.Output):Void
    {
        output.writeBlob(blob);
    }
}