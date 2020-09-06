package grig.osc;

import haxe.io.Bytes;

/**
    Static extension for some utility stuff on haxe bytes
**/
class BytesTypes
{
    public static function getInt32BigEndian(bytes:Bytes, pos:Int):Int
    {
        return (bytes.get(pos) << 24) | (bytes.get(pos + 1) << 16) | (bytes.get(pos + 2) << 8) | bytes.get(pos + 3);
    }
}