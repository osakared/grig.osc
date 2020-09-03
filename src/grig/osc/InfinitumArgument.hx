package grig.osc;

class InfinitumArgument extends Argument
{
    public function new()
    {
        super(ArgumentType.Infinitum);
    }

    override private function get_value():String
    {
        return 'inf';
    }
}