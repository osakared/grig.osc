package grig.osc.argument;

class BooleanArgument extends Argument
{
    public var val(default, null):Bool;

    public function new(val:Bool)
    {
        super(if (val) ArgumentType.True else ArgumentType.False);
        this.val = val;
    }

    override private function get_value():String
    {
        return '$val';
    }
}