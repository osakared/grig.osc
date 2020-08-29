package grig.osc;

class Argument
{
    public var val(default, null):Any;
    public var type(default, null):ArgumentType;

    public function new(val:Any, type:ArgumentType)
    {
        this.val = val;
        this.type = type;
    }
}