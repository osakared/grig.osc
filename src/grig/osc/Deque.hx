package grig.osc;

class Deque<T>
{
    #if (target.threaded)
    private var array = new sys.thread.Deque<T>();
    #else
    private var array = new Array<T>();
    #end

    public function new()
    {
    }

    public function push(x:T):Void
    {
        #if (target.threaded)
        array.add(x);
        #else
        array.push(x);
        #end
    }

    public function pop(blocking:Bool):Null<T>
    {
        #if (target.threaded)
        return array.pop(blocking);
        #else
        return array.pop();
        #end
    }
}