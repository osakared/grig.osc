package grig.osc; #if (target.threaded)

import sys.thread.Thread;

class ThreadedWorkerRunner
{
    private var thread:Thread = null;
    private var running:Bool = false;
    private var callbacks = new Deque<SimpleCallback>();

    public function new()
    {
    }

    public function queue(callback:SimpleCallback):Void
    {
        callbacks.push(callback);
    }

    public function start():Void
    {
        thread = Thread.create(() -> {
            running = true;
            while (running) {
                var callback = callbacks.pop(false);
                if (callback != null) callback();
            }
        });
    }

    public function stop():Void
    {
        running = false;
    }
}

#end