package grig.osc.argument;

class MidiArgument extends Argument
{
    public var midiBytes:haxe.io.Bytes;

    public function new(midiBytes:haxe.io.Bytes)
    {
        super(ArgumentType.Midi);
        this.midiBytes = midiBytes;
    }

    override private function get_value():String
    {
        var str = '0x';
        for (i in 0...4) {
            str += StringTools.hex(midiBytes.get(i), 2);
        }
        return str;
    }

    override public function write(output:haxe.io.Output):Void
    {
        output.writeBytes(midiBytes, 0, 4);
    }
}