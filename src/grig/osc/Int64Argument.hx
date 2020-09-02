package grig.osc;

using thx.Int64s;

class Int64Argument extends Argument
{
    public function new(val:Int64)
    {
        super(val, ArgumentType.Int64);
    }

    public override function toString():String
    {
        var displayVal:Int64 = cast val;
        return '$type ${displayVal.toStr()}';
    }
}