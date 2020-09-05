package grig.osc;

import grig.osc.argument.Argument;

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
            s += ' ${argument.toString()}';
        }
        return s;
    }
}
