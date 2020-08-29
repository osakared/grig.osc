package grig.osc;

enum abstract ArgumentType(String)
{
    var Int32 = 'i';
    var Float32 = 'f';
    var String = 's';
    var Blob = 'b';
    var Int64 = 'h';
    var Time = 't';
    var Unknown = '';

    @:from static public function fromString(s:String)
    {
        return switch s {
            case 'i': Int32;
            case 'f': Float32;
            case 's': String;
            case 'b': Blob;
            case 'h': Int64;
            case 't': Time;
            default: Unknown;
        }
    }
}