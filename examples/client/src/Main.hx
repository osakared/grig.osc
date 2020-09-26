package;

import haxe.Timer;
import grig.osc.Message;

class Main
{
    public static function main()
    {
        var sender = new grig.osc.UdpPacketSender('localhost', 8000);
        var client = new grig.osc.Client(sender);


        var counter:Int = 0;
        var beatTimer = new Timer(500);
        beatTimer.run = function() {
            var message = new Message('/x');
            message.arguments.push(new grig.osc.argument.Float32Argument(0.4));
            client.sendMessage(message);
            if (counter == 4) beatTimer.stop();
            counter++;
        }
    }
}