package grig.osc;

import haxe.io.BytesOutput;

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

        output.writeString(message.address);
        writeTypeString(message, output);
    }

    private function writeTypeString(message:Message, output:BytesOutput):Void
    {
        var typeString = ',';

        for (argument in message.arguments) {
            if (argument.type == ArgumentType.Array) {
                typeString += '[';
                var subArguments:Array<Argument> = cast argument.val;
                for (subArgument in subArguments) {
                    typeString += subArgument.type;
                }
                typeString += ']';
            } else typeString += argument.type;
        }

        output.writeString(typeString);
    }

    private function writeArgument(argument:Argument, output:BytesOutput):Void
    {
        // switch argument.type {
        //     case ArgumentType.Array:

        // }
    }

    private function writeArray(argument:)
}