package grig.osc; #if (target.threaded || python)

#if python
import python.lib.ThreadLowLevel;
#else
import sys.thread.Thread;
#end

class ThreadedLoopRunner
{
    private var running:Bool = false;
    private var loop:SimpleCallback;
    private var startup:SimpleCallback;
    private var shutdown:SimpleCallback;

    public function new(loop:SimpleCallback, startup:SimpleCallback = null, shutdown:SimpleCallback = null)
    {
        this.loop = loop;
        this.startup = startup;
        this.shutdown = shutdown;
    }

    public function start()
    {
        #if python
        ThreadLowLevel.start_new_thread(thread, new python.Tuple<Dynamic>([]));
        #else
        Thread.create(thread);
        #end
    }

    private function thread()
    {
        running = true;
        if (startup != null) startup();
        while (running) {
            loop();
        }
        if (shutdown != null) shutdown();
    }

    public static function startMultiple(runners:Array<LoopRunner>):Void
    {
        for (runner in runners) {
            runner.start();
        }
    }

    public function stop():Void
    {
        running = false;
    }
}

#end