package grig.osc;

class MidiArgument extends HexArgument
{
    public function new(midiBytes:Int)
    {
        super(midiBytes, ArgumentType.Midi);
    }
}