package grig.osc;

import grig.osc.argument.ArgumentType;
import grig.osc.argument.ArrayArgument;
import haxe.io.BytesOutput;

using grig.osc.OutputTypes;

class Client
{
    private var sender:PacketSender;

    public function new(sender:PacketSender)
    {
        this.sender = sender;
    }

    public function sendMessage(message:Message)
    {
        var output = new BytesOutput();
        output.bigEndian = true;

        writeMessage(message, output);

        output.close();
        return sender.sendPacket(output.getBytes());
    }

    public function sendBundle(bundle:Bundle)
    {
        var output = new BytesOutput();
        output.bigEndian = true;

        output.writeMultipleFourString(bundle.address);
        output.writeTime(bundle.time);

        for (message in bundle.messages) {
            var messageOutput = new BytesOutput();
            messageOutput.bigEndian = true;
            writeMessage(message, messageOutput);
            messageOutput.close();
            var messageBytes = messageOutput.getBytes();
            output.writeInt32(messageBytes.length);
            output.write(messageBytes);
        }

        output.close();
        return sender.sendPacket(output.getBytes());
    }

    private function writeMessage(message:Message, output:BytesOutput):Void
    {
        output.writeMultipleFourString(message.address);
        writeTypeString(message, output);

        for (argument in message.arguments) {
            argument.write(output);
        }
    }

    private function writeTypeString(message:Message, output:BytesOutput):Void
    {
        var typeString = ',';

        for (argument in message.arguments) {
            if (argument.type == ArgumentType.Array) {
                var arrayArgument:ArrayArgument = cast argument;
                typeString += '[';
                for (subArgument in arrayArgument.arguments) {
                    typeString += subArgument.type;
                }
                typeString += ']';
            } else typeString += argument.type;
        }

        output.writeMultipleFourString(typeString);
    }
}