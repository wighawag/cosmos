import cosmos.Model;
import test.Populator;
import test.Presenter;
import test.TestSystem;

class CosmosTest{
	public static function main(){
		var model = new Model([new TestSystem(), new Populator()]);
		model.update(0.02, 0.02);
		model.addPresenter(new Presenter());
	}
}