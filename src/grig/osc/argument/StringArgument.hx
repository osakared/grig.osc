package grig.osc.argument;

using grig.osc.OutputTypes;

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

    override public function write(output:haxe.io.Output):Void
    {
        output.writeMultipleFourString(val);
    }
}