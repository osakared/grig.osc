package grig.osc;

using grig.osc.OutputTypes;

class SymbolArgument extends Argument
{
    public var val(default, null):String;

    public function new(val:String)
    {
        super(ArgumentType.Symbol);
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