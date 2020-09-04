package grig.osc;

class ArrayArgument extends Argument
{
    public var arguments(default, null):Array<Argument>;

    public function new(arguments:Array<Argument>)
    {
        super(ArgumentType.Array);
        this.arguments = arguments;
    }

    override private function get_value():String
    {
        return '[' + [for (argument in arguments) argument.toString()].join(', ') + ']';
    }

    override public function write(output:haxe.io.Output):Void
    {
        for (argument in arguments) {
            argument.write(output);
        }
    }
}