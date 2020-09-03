package grig.osc;

class DoubleArgument extends Argument
{
    public var val(default, null):Float;

    public function new(val:Float)
    {
        super(ArgumentType.Double);
        this.val = val;
    }

    override private function get_value():String
    {
        return '$val';
    }
}