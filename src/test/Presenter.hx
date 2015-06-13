package test;
import comp.TestComponent;
import cosmos.CosmosPresenter;
import cosmos.Entities;


class Presenter implements CosmosPresenter
{

	var set1 : Entities<{test:TestComponent}>;
	
	function start(now : Float) {
		trace("start");
		for (entity in set1) {
			trace(entity);
		}
	}
	
}