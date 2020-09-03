package grig.osc;

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
}