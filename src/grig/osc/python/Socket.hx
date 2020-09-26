package grig.osc.python; #if python

import python.Tuple;

@:pythonImport("socket", "socket")
@:native("Socket")
extern class Socket
{
    public function new(family:Int, type:Int):Void;
    public function bind(address:python.lib.socket.Address):Void;
    public function sendto(bytes:python.Bytes, address:python.lib.socket.Address):Void;
    public function recvfrom(bufsize:Int):Tuple2<python.Bytes, python.lib.socket.Address>;
    public function close():Void;
}

#end