package grig.osc.argument;

using grig.osc.InputTypes;

class HexArgument extends Argument
{
    public var val(default, null):Int;

    public function new(val:Int, type:ArgumentType)
    {
        super(type);
        this.val = val;
    }

    override private function get_value():String
    {
        return '0x${StringTools.hex(val, 8)}';
    }

    override public function write(output:haxe.io.Output):Void
    {
        output.writeInt32(val);
    }
}