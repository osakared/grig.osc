package grig.osc;

class NilArgument extends Argument
{
    public function new()
    {
        super(null, ArgumentType.Nil);
    }
}