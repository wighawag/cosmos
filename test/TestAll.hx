package;

using utest.Assert;
import utest.Runner;
import utest.ui.Report;

class TestAll
{

	public static function main() {
		var runner = new Runner();

		runner.addCase(new TestAll());

		Report.create(runner);
		runner.run();
	}

	public function new() {}
	
}