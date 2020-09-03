package grig.osc;

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
}