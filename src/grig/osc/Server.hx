package grig.osc;

import grig.osc.OSCCallback;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.Input;

using StringTools;
using thx.Int64s;

class Server
{
    private var transport:PacketReceiver;
    private var callbacks = new Array<Callback>();
    private var running:Bool = false;

    public var numCallbacks(get, null):Int;

    private function get_numCallbacks():Int
    {
        return callbacks.length;
    }

    public function new(transport:PacketReceiver)
    {
        this.transport = transport;
    }

    /**
     * Registers a callback with optional pattern, which can contain regex
     * @param callback 
     * @param pattern String containing 
     */
    public function registerCallback(callback:OSCCallback, pattern:String = '', isRegex:Bool = false, argumentTypes:Array<ArgumentType> = null):Void
    {
        callbacks.push(new Callback(callback, pattern, isRegex, argumentTypes));
    }

    public function deregisterCallbacks(pattern:String):Void
    {
        callbacks = [for (callback in callbacks) {
            if (callback.pattern != pattern) callback;
        }];
    }

    public function deregisterAllCallbacks():Void
    {
        callbacks = [];
    }

    public function dispatchMessage(message:Message):Void
    {
        for (callback in callbacks) {
            callback.matchAndCall(message);
        }
    }

    public function start():Void
    {
        running = true;
        Thread.create(() -> {
            while (running) {
                var bytes = transport.getPacket();
                var input = new BytesInput(bytes);
                input.bigEndian = true;
                var s = readString(input);
                if (s.startsWith('/')) {
                    dispatchMessage(readMessage(s, input));
                }
                else if (s.startsWith('#')) {
                    for (message in readBundle(s, input).messages) {
                        dispatchMessage(message);
                    }
                }
            }
        });
    }

    public function close():Void
    {
        running = false;
    }

    private static function toArgument(typeString:String, input:BytesInput):Argument
    {
        var type:ArgumentType = typeString;
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
                return new Int64Argument(readInt64(input));
            case ArgumentType.Time:
                readTime(input);
            case ArgumentType.Double:
                input.readDouble();
            case ArgumentType.Symbol:
                readString(input);
            case ArgumentType.Char:
                readChar(input);
            case ArgumentType.Color:
                return new HexArgument(readUInt32(input), type);
            case ArgumentType.Midi:
                return new HexArgument(readUInt32(input), type);
            case ArgumentType.True:
                true;
            case ArgumentType.False:
                false;
            case ArgumentType.Nil:
                null;
            case ArgumentType.Infinitum:
                Math.POSITIVE_INFINITY;
            default:
                null;
        }
        return new Argument(val, type);
    }

    private static function readMessage(address:String, input:BytesInput):Message
    {
        var message = new Message(address);

        var type = readString(input);
        var inArray = false;
        var subArguments:Array<Argument> = null;
        for (c in type.substr(1).split('')) {
            if (inArray) {
                if (c == ']') {
                    inArray = false;
                    message.arguments.push(new Argument(subArguments, ArgumentType.Array));
                    subArguments = null;
                    continue;
                }
                if (subArguments != null) subArguments.push(toArgument(c, input));
            }
            else if (c == '[') {
                inArray = true;
                subArguments = new Array<Argument>();
            }
            else message.arguments.push(toArgument(c, input));
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
        var secs1990 = Int64.make(0, readUInt32(input)).toFloat();
        var picoseconds = Int64.make(0, readUInt32(input)).toFloat();
        if (secs1990 == 0 && picoseconds == 1) return Date.now();
        var seconds:Float = secs1990 - 2208988800 + picoseconds / 4294967296;
        return Date.fromTime(seconds * 1000.0);
    }

    /**
     * Reads big endian signed int32 as an Int64
     * @param input 
     * @return Int64
     */
    public static function readUInt32(input:Input):Int
    {
        var b1 = input.readByte();
        var b2 = input.readByte();
        var b3 = input.readByte();
        var b4 = input.readByte();
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

    private static function readChar(input:BytesInput):String
    {
        var val = input.readInt32();
        return String.fromCharCode(val);
    }
}