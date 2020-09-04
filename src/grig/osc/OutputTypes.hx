package grig.osc;

import haxe.io.Output;

using thx.Int64s;

/**
 * Static extensions for `Output` to assist in writing OSC `Message`s
 */
class OutputTypes
{
    public static function writeMultipleFourString(output:Output, string:String):Void
    {
        output.writeString(string);
        output.writeByte(0);
        var remainder = (string.length + 1) % 4;
        if (remainder > 0) {
            for (i in 0...(4 - remainder)) {
                output.writeByte(0);
            }
        }
    }

    // This code blatantly stolen from https://github.com/colinbdclark/osc.js and ported
    // Copyright Colin Clark
    public static function writeTime(output:Output, time:Date):Void
    {
        var secs = time.getTime() / 1000.0;
        var secsWhole = Math.floor(secs);
        var secsFrac = secs - secsWhole;
        var ntpSecs = Int64.fromFloat(secsWhole + 2208988800);
        var ntpFracs = Math.round(4294967296 * secsFrac);
        output.writeInt32(ntpSecs.low);
        output.writeInt32(ntpFracs);
    }

    public static function writeBlob(output:Output, blob:haxe.io.Bytes):Void
    {
        output.writeInt32(blob.length);
        output.write(blob);
        var remainder = (blob.length) % 4;
        if (remainder > 0) {
            for (i in 0...(4 - remainder)) {
                output.writeByte(0);
            }
        }
    }
}
