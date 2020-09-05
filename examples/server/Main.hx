package;

import grig.osc.UdpSocket;
import grig.osc.Server;
import sys.net.Host;

class Main
{
    public static function main()
    {
        var socket = new UdpSocket();
        socket.bind('0.0.0.0', 8000);
        var server = new Server(socket);
        server.registerCallback((message) -> {
            trace(message.toString());
        });
        #if (sys && !nodejs)
        var stdout = Sys.stdout();
        var stdin = Sys.stdin();
        // Using Sys.getChar() unfortunately fucks up the output
        stdout.writeString('quit[enter] to quit\n');
        while (true) {
            var command = stdin.readLine();
            if (command.toLowerCase() == 'quit') {
                socket.close();
                return;
            }
        }
        #end
    }
}