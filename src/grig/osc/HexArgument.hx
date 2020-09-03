package grig.osc;

using grig.osc.InputTypes;
import haxe.io.Input;

class HexArgument extends Argument
{
    public function new(val:Int, type:ArgumentType)
    {
        super(val, type);
    }

    public static function fromInput(input:Input, type:ArgumentType):HexArgument
    {
        return new HexArgument(input.readUInt32(), type);
    }

    public override function toString():String
    {
        var displayVal:Int = cast val;
        return '$type 0x${StringTools.hex(displayVal, 8)}';
    }
}