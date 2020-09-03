package grig.osc;

class CharArgument extends Argument
{
    public var char(default, null):String;

    public function new(char:String)
    {
        super(ArgumentType.Char);
        this.char = char;
    }

    override private function get_value():String
    {
        return char;
    }
}