package grig.osc;

using grig.osc.InputTypes;

class HexArgument extends Argument
{
    public var val(default, null):Int;

    public function new(val:Int, type:ArgumentType)
    {
        super(type);
        this.val = val;
    }

    private override function get_value():String
    {
        return '0x${StringTools.hex(val, 8)}';
    }
}