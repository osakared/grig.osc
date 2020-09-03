package grig.osc;

import grig.osc.OSCCallback;
import haxe.io.BytesInput;

using grig.osc.InputTypes;
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
        });
    }

    public function close():Void
    {
        running = false;
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