package grig.osc;

class Bundle
{
    public var address(default, null):String;
    public var time(default, null):Date;
    public var messages(default, null) = new Array<Message>();

    public function new(address:String, time:Date)
    {
        this.address = address;
        this.time = time;
    }

    public function toString():String
    {
        var s = '${this.address} $time:';
        for (message in messages) {
            s += '\n\t${message.toString()}';
        }
        return s;
    }
}