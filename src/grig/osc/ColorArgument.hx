package grig.osc;

class ColorArgument extends HexArgument
{
    public function new(color:Int)
    {
        super(color, ArgumentType.Color);
    }
}