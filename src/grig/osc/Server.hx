package grig.osc;

import haxe.io.Bytes;
import haxe.io.Input;

using StringTools;

class Server
{
    private var transport:Input;

    public function new(transport:Input)
    {
        this.transport = transport;
        this.transport.bigEndian = true;
    }

    public function waitForMessages():Void
    {
        while (true) {
            var s = readString();
            if (s.startsWith('/')) {
                var message = readMessage(s);
                trace(message.toString());
            }
            else trace(s.length);
        }
    }

    private function readMessage(address:String):Message
    {
        var message = new Message(address);

        var type = readString();
        for (c in type.substr(1).split('')) {
            var type:ArgumentType = c;
            var val:Any = switch type {
                case ArgumentType.Float32:
                    transport.readFloat();
                case ArgumentType.Int32:
                    transport.readInt32();
                case ArgumentType.String:
                    readString();
                case ArgumentType.Blob:
                    readBlob();
                default:
                    trace(c);
                    null;
                }
            message.arguments.push(new Argument(val, type));
        }

        return message;
    }

    private function readString():String
    {
        // This seems not very efficient
        var s = '';
        var b:Int = 0;
        var charsRead = 0;
        while (true) {
            b = transport.readByte();
            charsRead++;
            if (b == 0) break;
            s += String.fromCharCode(b);
        }
        var remainder = charsRead % 4;
        if (remainder > 0) transport.read(4 - remainder);

        return s;
    }

    private function readBlob():Bytes
    {
        var len = transport.readInt32();
        len = (len + 3) & ~0x03;
        return transport.read(len);
    }
}