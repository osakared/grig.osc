package grig.osc.argument;

enum abstract ArgumentType(String)
{
    var Int32 = 'i';
    var Float32 = 'f';
    var String = 's';
    var Blob = 'b';
    var Int64 = 'h';
    var Time = 't';
    var Double = 'd';
    var Symbol = 'S';
    var Char = 'c';
    var Color = 'r';
    var Midi = 'm';
    var True = 'T';
    var False = 'F';
    var Nil = 'N';
    var Infinitum = 'I';
    var Array = '[';
    var None = '';

    @:from static public function fromString(s:String)
    {
        return switch s {
            case 'i': Int32;
            case 'f': Float32;
            case 's': String;
            case 'b': Blob;
            case 'h': Int64;
            case 't': Time;
            case 'd': Double;
            case 'S': Symbol;
            case 'c': Char;
            case 'r': Color;
            case 'm': Midi;
            case 'T': True;
            case 'F': False;
            case 'N': Nil;
            case 'I': Infinitum;
            case '[': Array;
            default: None;
        }
    }
}