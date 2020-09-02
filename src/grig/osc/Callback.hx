package grig.osc;

/**
 * Represents matching parameters and a callback
 */
class Callback
{
    private var callback:OSCCallback;
    public var pattern(default, null):String;
    private var isRegex:Bool;
    private var argumentTypes:Array<ArgumentType>;

    public function new(callback:OSCCallback, pattern:String, isRegex:Bool = false, _argumentTypes:Array<ArgumentType> = null)
    {
        this.callback = callback;
        this.pattern = pattern;
        this.isRegex = isRegex;
        this.argumentTypes = if (_argumentTypes == null) new Array<ArgumentType>() else _argumentTypes;
    }

    /**
     * Calls callack if there's a match with address
     */
    public function matchAndCall(message:Message):Void
    {
        if (pattern != '') {
            if (isRegex) {
                var matcher = new EReg(pattern, '');
                if (!matcher.match(message.address)) return;
            }
            else if (pattern != message.address) return;
        }

        if (argumentTypes.length > 0) {
            if (argumentTypes.length != message.arguments.length) return;
            for (i in 0...argumentTypes.length) {
                if (argumentTypes[i] != message.arguments[i].type) return;
            }
        }

        callback(message);
    }
}