package grig.osc.argument;

using thx.Int64s;

class Int64Argument extends Argument
{
    var val:Int64;

    public function new(val:Int64)
    {
        super(ArgumentType.Int64);
        this.val = val;
    }

    override private function get_value():String
    {
        return val.toStr();
    }

    override public function write(output:haxe.io.Output):Void
    {
        output.writeInt32(val.high);
        output.writeInt32(val.low);
    }
}