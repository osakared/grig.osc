package grig.osc;

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
        var displayVal:String = if (Reflect.hasField(val, 'toStr')) {
            Reflect.callMethod(val, Reflect.field(val, 'toStr'), []);
        } else {
            '${this.val}';
        }
        return '$type $displayVal';
    }
}