package grig.osc;

#if (openfl && !disable_openfl_socket)
typedef TcpSocket = grig.osc.openfl.TcpSocket;
#else

import haxe.io.Bytes;
import sys.net.Socket;

/**
    Abstract so that we can use `haxe.io.Socket` or `openfl.netSocket` if available and not disabled
**/
@:forward(close)
abstract TcpSocket(Socket)
{
    public var bigEndian(get, set):Bool;

    public inline function new()
    {
        this = new Socket();
    }

    public inline function readInt32():Int
    {
        return this.input.readInt32();
    }

    public inline function read(nbytes:Int):Bytes
    {
        return this.input.read(nbytes);
    }

    public inline function writeInt32(val:Int):Void
    {
        this.output.writeInt32(val);
    }

    public inline function write(bytes:Bytes):Void
    {
        this.output.write(bytes);
    }

    public inline function connect(host:String, port:Int):Void
    {
        return this.connect(new sys.net.Host(host), port);
    }

    private inline function get_bigEndian():Bool
    {
        return this.input.bigEndian;
    }

    private inline function set_bigEndian(endian:Bool):Bool
    {
        return this.input.bigEndian = this.output.bigEndian = endian;
    }
}

#end