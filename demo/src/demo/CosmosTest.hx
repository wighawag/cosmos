package demo;

import cosmos.Model;
import demo.system.Populator;
import demo.system.Presenter;
import demo.system.TestSystem;

class CosmosTest{
	public static function main(){
		var model = new Model([new TestSystem(), new Populator()]);
		model.start(0);
		model.update(0.02, 0.02);
		model.addPresenter(new Presenter());
	}
}