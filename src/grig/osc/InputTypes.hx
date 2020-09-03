package grig.osc;

import haxe.io.Input;

class InputTypes
{
    /**
     * Reads big endian signed int32 as an Int but doesn't try to force signed on platforms without it
     * @param input input to read from
     * @return Int regular haxe Int, which is actually signed
     */
    public static function readUInt32(input:Input):Int
    {
        var b1 = input.readByte();
        var b2 = input.readByte();
        var b3 = input.readByte();
        var b4 = input.readByte();
        return (b1 << 24) | (b2 << 16) | (b3 << 8) | b4;
    }
}