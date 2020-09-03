package grig.osc;

class TimeArgument extends Argument
{
    public function new(time:Date)
    {
        super(time, ArgumentType.Time);
    }
}