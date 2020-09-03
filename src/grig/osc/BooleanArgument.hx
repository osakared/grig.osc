package grig.osc;

class BooleanArgument extends Argument
{
    public function new(truth:Bool)
    {
        super(truth, if (truth) ArgumentType.True else ArgumentType.False);
    }
}