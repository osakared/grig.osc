package grig.osc;

class StringArgument extends Argument
{
    public var val(default, null):String;

    public function new(val:String)
    {
        super(ArgumentType.String);
        this.val = val;
    }

    override private function get_value():String
    {
        return val;
    }
}