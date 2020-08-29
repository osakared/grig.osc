package grig.osc;

class Message extends Packet
{
    public var arguments(default, null) = new Array<Argument>();

    public function new(address:String)
    {
        super(address);
    }

    public override function toString():String
    {
        var s = '${this.address} :';
        for (argument in arguments) {
            s += ' ${argument.type} ${argument.val}';
        }
        return s;
    }
}
