package;

import grig.osc.UdpListener;
import grig.osc.Server;
import sys.net.Host;

class Main
{
    public static function main()
    {
        var listener = new UdpListener();
        listener.bind(new Host(Host.localhost()), 8000);
        var server = new Server(listener.input);
        server.waitForMessages();
    }
}