package grig.osc;

class NilArgument extends Argument
{
    public function new()
    {
        super(ArgumentType.Nil);
    }

    override private function get_value():String
    {
        return 'null';
    }
}