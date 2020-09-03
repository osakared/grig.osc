package grig.osc;

import haxe.io.Input;
using thx.Int64s;

class Argument
{
    public var val(default, null):Any;
    public var type(default, null):ArgumentType;

    public function new(val:Any, type:ArgumentType)
    {
        this.val = val;
        this.type = type;
    }

    public function toString():String
    {
        return '$type $val';
    }
}