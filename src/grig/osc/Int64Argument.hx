package grig.osc;

using thx.Int64s;

class Int64Argument extends Argument
{
    var val:Int64;

    public function new(val:Int64)
    {
        super(ArgumentType.Int64);
        this.val = val;
    }

    private override function get_value():String
    {
        return val.toStr();
    }
}