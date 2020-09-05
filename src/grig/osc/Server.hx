package grig.osc;

import grig.osc.OSCCallback;
import grig.osc.argument.Argument;
import grig.osc.argument.ArgumentType;
import grig.osc.argument.ArrayArgument;
import grig.osc.argument.BooleanArgument;
import grig.osc.argument.Float32Argument;
import grig.osc.argument.InfinitumArgument;
import grig.osc.argument.NilArgument;
import haxe.io.BytesInput;

using grig.osc.InputTypes;
using StringTools;
using thx.Int64s;

class Server
{
    private var callbacks = new Array<Callback>();

    public var numCallbacks(get, null):Int;

    private function get_numCallbacks():Int
    {
        return callbacks.length;
    }

    public function new(transport:PacketListener)
    {
        transport.registerCallback(onPacket);
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

    /**
     * Convenience function to just expect a single float callback
     */
    public function registerFloat32Callback(callback:(value:Float)->Void, pattern:String):Void
    {
        callbacks.push(new Callback((message) -> {
            if (!Std.isOfType(message, Float32Argument)) return;
            var argument:Float32Argument = cast message;
            callback(argument.val);
        }, pattern, false, [ArgumentType.Float32]));
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

    public function onPacket(bytes:haxe.io.Bytes):Void
    {
        var input = new BytesInput(bytes);
        input.bigEndian = true;
        var s = input.readMultipleFourString();
        if (s.startsWith('/')) {
            dispatchMessage(readMessage(s, input));
        }
        else if (s.startsWith('#')) {
            for (message in readBundle(s, input).messages) {
                dispatchMessage(message);
            }
        }
    }

    private static function toArgument(typeString:String, input:BytesInput):Argument
    {
        var type:ArgumentType = typeString;
        return switch type {
            case ArgumentType.Float32:
                input.readFloat32Argument();
            case ArgumentType.Int32:
                input.readInt32Argument();
            case ArgumentType.String:
                input.readStringArgument();
            case ArgumentType.Blob:
                input.readBlobArgument();
            case ArgumentType.Int64:
                input.readInt64Argument();
            case ArgumentType.Time:
                input.readTimeArgument();
            case ArgumentType.Double:
                input.readDoubleArgument();
            case ArgumentType.Symbol:
                input.readSymbolArgument();
            case ArgumentType.Char:
                input.readCharArgument();
            case ArgumentType.Color:
                input.readColorArgument();
            case ArgumentType.Midi:
                input.readMidiArgument();
            case ArgumentType.True:
                new BooleanArgument(true);
            case ArgumentType.False:
                new BooleanArgument(false);
            case ArgumentType.Nil:
                new NilArgument();
            case ArgumentType.Infinitum:
                new InfinitumArgument();
            default:
                new Argument(type);
        }
    }

    private static function readMessage(address:String, input:BytesInput):Message
    {
        var message = new Message(address);

        var type = input.readMultipleFourString();
        var inArray = false;
        var subArguments:Array<Argument> = null;
        for (c in type.substr(1).split('')) {
            if (inArray) {
                if (c == ']') {
                    inArray = false;
                    message.arguments.push(new ArrayArgument(subArguments));
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
        var time = input.readTime();
        var bundle = new Bundle(address, time);

        while (input.length - input.position > 0) {
            input.readInt32();
            var address = input.readMultipleFourString();
            var message = readMessage(address, input);
            bundle.messages.push(message);
        }

        return bundle;
    }
}