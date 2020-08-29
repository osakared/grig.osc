package grig.osc;

class Packet
{
    public var address(default, null):String;

    public function new(address:String)
    {
        this.address = address;
    }

    public function toString():String
    {
        return address;
    }
}