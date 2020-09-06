package grig.osc;

#if (target.threaded)
typedef WorkerRunner = ThreadedWorkerRunner;
#else

/**
    Abstracts over a thread or a simple loop, depending on if the environment has threading implemented or not
**/
class WorkerRunner
{
    public function new()
    {
    }

    public function queue(callback:SimpleCallback):Void
    {
        callback();
    }

    public function start():Void
    {
    }

    public function stop():Void
    {
    }
}

#end