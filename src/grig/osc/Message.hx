package grig.osc;

class Message
{
    public var address(default, null):String;
    public var arguments(default, null) = new Array<Argument>();

    public function new(address:String)
    {
        this.address = address;
    }

    public function toString():String
    {
        var s = '${this.address} :';
        for (argument in arguments) {
            s += ' ${argument.type} ${argument.val}';
        }
        return s;
    }
}
