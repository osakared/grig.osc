package;

import grig.osc.UdpListener;
import grig.osc.Server;
import sys.net.Host;

class Main
{
    public static function main()
    {
        var listener = new UdpListener();
        listener.bind(new Host('0.0.0.0'), 8000);
        var server = new Server(listener.receiver);
        server.setCallback((packet) -> {
            trace(packet.toString());
        });
        server.start();
        #if (sys && !nodejs)
        var stdout = Sys.stdout();
        var stdin = Sys.stdin();
        // Using Sys.getChar() unfortunately fucks up the output
        stdout.writeString('quit[enter] to quit\n');
        while (true) {
            var command = stdin.readLine();
            if (command.toLowerCase() == 'quit') {
                server.close();
                listener.close();
                return;
            }
        }
        #end
    }
}