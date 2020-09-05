package grig.osc.argument;

using thx.Int64s;

class Argument
{
    public var type(default, null):ArgumentType;
    public var value(get, never):String;

    private function get_value():String
    {
        return '';
    }

    public function new(type:ArgumentType)
    {
        this.type = type;
    }

    public function toString():String
    {
        return '$type $value';
    }

    public function write(output:haxe.io.Output):Void
    {
    }
}