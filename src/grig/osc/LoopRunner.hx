package grig.osc;

#if (target.threaded)
typedef LoopRunner = ThreadedLoopRunner;
#else

/**
    Represents something that runs a loop, can be a thread or just a blocking loop. This is the blocking non-threaded version
**/
class LoopRunner
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

    public function start():Void
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
            runner.running = true;
            if (runner.startup != null) runner.startup();
        }
        var runnersToRemove = new Array<LoopRunner>();
        while (runners.length > 0) {
            for (runner in runners) {
                if (runner.running) runner.loop();
                else {
                    if (runner.shutdown != null) runner.shutdown();
                    runnersToRemove.push(runner);
                }
            }
            if (runnersToRemove.length > 0) {
                runners = [for (runner in runners) { if (!runnersToRemove.contains(runner)) runner; }];
                runnersToRemove = [];
            }
        }
    }

    public function stop():Void
    {
        running = false;
    }
}

#end