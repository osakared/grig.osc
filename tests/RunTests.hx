package;
  
import tink.testrunner.*;
import tink.unit.*;

class RunTests {

    static function main()
    {
        Runner.run(TestBatch.make([
            new TcpTest(),
            new UdpServerTest(),
            new UdpClientTest(),
        ])).handle(Runner.exit);
    }

}