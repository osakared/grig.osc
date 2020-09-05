package grig.osc.argument;

using grig.osc.OutputTypes;

class TimeArgument extends Argument
{
    public var time(default, null):Date;

    public function new(time:Date)
    {
        super(ArgumentType.Time);
        this.time = time;
    }

    override private function get_value():String
    {
        return '$time';
    }

    override public function write(output:haxe.io.Output):Void
    {
        output.writeTime(time);
    }
}