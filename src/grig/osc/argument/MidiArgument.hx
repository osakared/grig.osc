package grig.osc.argument;

class MidiArgument extends HexArgument
{
    public function new(midiBytes:Int)
    {
        super(midiBytes, ArgumentType.Midi);
    }
}