package grig.osc;

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
}