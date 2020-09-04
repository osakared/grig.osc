package grig.osc;

import haxe.io.BytesOutput;

using grig.osc.OutputTypes;

class Client
{
    private var sender:PacketSender;

    public function new(sender:PacketSender)
    {
        this.sender = sender;
    }

    public function sendMessage(message:Message):Void
    {
        var output = new BytesOutput();
        output.bigEndian = true;

        output.writeMultipleFourString(message.address);
        writeTypeString(message, output);

        for (argument in message.arguments) {
            argument.write(output);
        }

        output.close();
        sender.sendPacket(output.getBytes());
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

    // private function writeArgument(argument:Argument, output:BytesOutput):Void
    // {
    //     switch argument.type {
    //         case ArgumentType.Array:

    //     }
    // }

    // private function writeArray(argument:)
}