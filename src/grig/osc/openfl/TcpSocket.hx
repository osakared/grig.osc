package grig.osc.openfl; #if (openfl && !disable_openfl_socket)

import haxe.io.Bytes;
import openfl.net.Socket;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

@:forward(connect, close)
abstract TcpSocket(Socket)
{
    public var bigEndian(get, set):Bool;

    public inline function new()
    {
        this = new Socket();
    }

    public inline function readInt32():Int
    {
        return this.readInt();
    }

    public inline function read(nbytes:Int):Bytes
    {
        var bytes = new ByteArray();
        this.readBytes(bytes, 0, nbytes);
        return bytes;
    }

    public inline function writeInt32(val:Int):Void
    {
        this.writeInt(val);
    }

    public inline function write(bytes:Bytes):Void
    {
        this.writeBytes(bytes);
    }

    private inline function get_bigEndian():Bool
    {
        return this.endian == Endian.BIG_ENDIAN;
    }

    private inline function set_bigEndian(endian:Bool):Bool
    {
        this.endian = if (endian) Endian.BIG_ENDIAN else Endian.LITTLE_ENDIAN;
        return endian;
    }
}

#end