package;

import grig.osc.argument.Float32Argument;
import grig.osc.Bundle;
import grig.osc.Client;
import grig.osc.Message;
// import grig.osc.PacketSender;
import grig.osc.UdpPacketSender;
import grig.osc.TcpClient;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;

class Main extends Sprite
{
    private var client:Client;

    public function new()
    {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);

        var sender = new UdpPacketSender('localhost', 8000);
        // var sender = new TcpClient();
        // sender.connect('localhost', 8000);
        client = new Client(sender);
    }

    private function init(event):Void
    {
        trace('init');
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
    }

    private function onMouseEvent(event:MouseEvent):Void
    {
        if (!event.buttonDown) return;
        var width = stage.stageWidth;
        var x = Math.min(Math.max(event.stageX, 0.0), width);
        x = x / width;
        var height = stage.stageHeight;
        var y = Math.min(Math.max(event.stageY, 0.0), height);
        y = 1.0 - y / height;
        stage.color = Std.int(0xff * y) | (Std.int(0xff * x) << 16);

        var bundle = new Bundle('#bundle', Date.now());
        var message = new Message('/x');
        message.arguments.push(new Float32Argument(x));
        bundle.messages.push(message);
        message = new Message('/y');
        message.arguments.push(new Float32Argument(y));
        bundle.messages.push(message);
        client.sendBundle(bundle);
    }
}