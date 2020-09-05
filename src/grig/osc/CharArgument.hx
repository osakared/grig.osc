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

    override public function write(output:haxe.io.Output):Void
    {
        var character = if (char.length > 0) char.charCodeAt(0) else ' '.charCodeAt(0);
        output.writeInt32(character);
    }
}