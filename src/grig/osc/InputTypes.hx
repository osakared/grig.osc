package grig.osc;

import haxe.io.Bytes;
import haxe.io.Input;

using thx.Int64s;

/**
    Static extension to allow extracting `Argument`s from an `Input`.
**/
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

    public static function readColorArgument(input:Input):ColorArgument
    {
        return new ColorArgument(readUInt32(input));
    }

    public static function readMidiArgument(input:Input):MidiArgument
    {
        return new MidiArgument(readUInt32(input));
    }

    public static function readFloat32Argument(input:Input):Float32Argument
    {
        return new Float32Argument(input.readFloat());
    }

    public static function readInt32Argument(input:Input):Int32Argument
    {
        return new Int32Argument(input.readInt32());
    }

    public static function readMultipleFourString(input:Input):String
    {
        // This seems not very efficient
        var s = '';
        var b:Int = 0;
        var charsRead = 0;
        while (true) {
            b = input.readByte();
            charsRead++;
            if (b == 0) break;
            s += String.fromCharCode(b);
        }
        var remainder = charsRead % 4;
        if (remainder > 0) input.read(4 - remainder);

        return s;
    }

    public static function readStringArgument(input:Input):StringArgument
    {
        return new StringArgument(readMultipleFourString(input));
    }

    public static function readBlob(input:Input):Bytes
    {
        var len = input.readInt32();
        len = (len + 3) & ~0x03;
        return input.read(len);
    }

    public static function readBlobArgument(input:Input):BlobArgument
    {
        return new BlobArgument(readBlob(input));
    }

    /**
     * Reads big endian Int64
     * @param input 
     * @return Int64
     */
    public static function readInt64(input:Input):Int64
    {
        var b1 = input.readInt32();
        var b2 = input.readInt32();
        return Int64.make(b1, b2);
    }

    public static function readInt64Argument(input:Input):Int64Argument
    {
        return new Int64Argument(readInt64(input));
    }

    public static function readTime(input:Input):Date
    {
        var secs1990 = Int64.make(0, readUInt32(input)).toFloat();
        var picoseconds = Int64.make(0, readUInt32(input)).toFloat();
        if (secs1990 == 0 && picoseconds == 1) return Date.now();
        var seconds:Float = secs1990 - 2208988800 + picoseconds / 4294967296;
        return Date.fromTime(seconds * 1000.0);
    }

    public static function readTimeArgument(input:Input):TimeArgument
    {
        return new TimeArgument(readTime(input));
    }

    public static function readDoubleArgument(input:Input):DoubleArgument
    {
        return new DoubleArgument(input.readDouble());
    }

    public static function readSymbolArgument(input:Input):SymbolArgument
    {
        return new SymbolArgument(readMultipleFourString(input));
    }

    public static function readChar(input:Input):String
    {
        var val = input.readInt32();
        return String.fromCharCode(val);
    }

    public static function readCharArgument(input:Input):CharArgument
    {
        return new CharArgument(readChar(input));
    }
}