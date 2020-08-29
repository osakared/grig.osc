package grig.osc;

class Bundle extends Packet
{
    public var time(default, null):Date;
    public var messages(default, null) = new Array<Message>();

    public function new(address:String, time:Date)
    {
        super(address);
        this.time = time;
    }

    public override function toString():String
    {
        var s = '${this.address} $time:';
        for (message in messages) {
            s += '\n\t${message.toString()}';
        }
        return s;
    }
}