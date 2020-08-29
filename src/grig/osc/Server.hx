package grig.osc;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;

using StringTools;
using thx.Int64s;

class Server
{
    private var transport:PacketReceiver;
    private var callback:OSCCallback = null;

    public function new(transport:PacketReceiver)
    {
        this.transport = transport;
    }

    public function setCallback(callback:OSCCallback):Void
    {
        this.callback = callback;
    }

    public function waitForMessages():Void
    {
        while (true) {
            var bytes = transport.getPacket();
            var input = new BytesInput(bytes);
            input.bigEndian = true;
            var s = readString(input);
            var packet = if (s.startsWith('/')) {
                readMessage(s, input);
            }
            else if (s.startsWith('#')) {
                readBundle(s, input);
            }
            else new Packet(s);
            trace(packet.toString());
            if (callback != null) callback(packet);
        }
    }

    private static function readMessage(address:String, input:BytesInput):Message
    {
        var message = new Message(address);

        var type = readString(input);
        for (c in type.substr(1).split('')) {
            var type:ArgumentType = c;
            var val:Any = switch type {
                case ArgumentType.Float32:
                    input.readFloat();
                case ArgumentType.Int32:
                    input.readInt32();
                case ArgumentType.String:
                    readString(input);
                case ArgumentType.Blob:
                    readBlob(input);
                case ArgumentType.Int64:
                    readInt64(input);
                case ArgumentType.Time:
                    readTime(input);
                default:
                    trace(c);
                    null;
                }
            message.arguments.push(new Argument(val, type));
        }

        return message;
    }

    private static function readBundle(address:String, input:BytesInput):Bundle
    {
        var time = readTime(input);
        var bundle = new Bundle(address, time);

        while (input.length - input.position > 0) {
            input.readInt32();
            var address = readString(input);
            var message = readMessage(address, input);
            bundle.messages.push(message);
        }

        return bundle;
    }

    private static function readString(input:BytesInput):String
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

    private static function readBlob(input:BytesInput):Bytes
    {
        var len = input.readInt32();
        len = (len + 3) & ~0x03;
        return input.read(len);
    }

    private static function readTime(input:BytesInput):Date
    {
        var secs1990 = readSInt32(input);
        var picoseconds = readSInt32(input);
        if (secs1990 == 0 && picoseconds == 1) return Date.now();
        var seconds:Int64 = secs1990 - Int64.fromFloat(2208988800) + picoseconds / Int64.fromFloat(4294967296);
        var timestamp:Int64 = seconds * 1000;
        return Date.fromTime(timestamp.toFloat());
    }

    /**
     * Reads big endian signed int32 as an Int64
     * @param input 
     * @return Int64
     */
    public static function readSInt32(input:Input):Int64
    {
        var b1:Int64 = input.readByte();
        var b2:Int64 = input.readByte();
        var b3:Int64 = input.readByte();
        var b4:Int64 = input.readByte();
        return (b1 << 24) | (b2 << 16) | (b3 << 8) | b4;
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
}