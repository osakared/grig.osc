package grig.osc.argument;

class Int32Argument extends Argument
{
    public var val(default, null):Int;

    public function new(val:Int)
    {
        super(ArgumentType.Int32);
        this.val = val;
    }

    override private function get_value():String
    {
        return '$val';
    }

    override public function write(output:haxe.io.Output):Void
    {
        output.writeInt32(val);
    }
}