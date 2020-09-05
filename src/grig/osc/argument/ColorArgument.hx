package grig.osc.argument;

class ColorArgument extends HexArgument
{
    public function new(color:Int)
    {
        super(color, ArgumentType.Color);
    }
}