package grig.osc;

import haxe.io.Output;

/**
 * Static extensions for `Output` to assist in writing OSC `Message`s
 */
class OutputTypes
{
    public static function writeMultipleFourString(output:Output, string:String):Void
    {
        output.writeString(string);
        var remainder = (string.length) % 4;
        if (remainder > 0) {
            for (i in 0...(4 - remainder)) {
                output.writeByte(0);
            }
        }
    }
}
