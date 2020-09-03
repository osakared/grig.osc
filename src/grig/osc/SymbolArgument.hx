package grig.osc;

class SymbolArgument extends Argument
{
    public function new(str:String)
    {
        super(str, ArgumentType.Symbol);
    }
}