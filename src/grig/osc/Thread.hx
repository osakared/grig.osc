package grig.osc;

class Thread
{
    public static function create(callback:()->Void):Void
    {
        #if (target.threaded)
        sys.thread.Thread.create(callback);
        #elseif python
        python.lib.ThreadLowLevel.start_new_thread(callback, new python.Tuple<Dynamic>());
        #end
    }
}