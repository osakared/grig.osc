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
        // This code is brittle and confusing. Basically, it's to help tests pass because Int64 looks different in different targets
        // All the types that store as Int64 so that the tests pass. There needs to be a better way to do that.
        var displayVal:String = if ([ArgumentType.Int64, ArgumentType.Color, ArgumentType.Midi].contains(type)) {
            var i:Int64 = cast val;
            i.toStr();
        } else {
            '${this.val}';
        }
        return '$type $displayVal';
    }
}