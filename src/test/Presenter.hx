package test;
import comp.TestComponent;
import cosmos.CosmosPresenter;
import cosmos.Entities;


class Presenter implements CosmosPresenter
{

	var set1 : Entities<{test:TestComponent}>;
	
	function initialise() {
		trace("initialise");
		for (entity in set1) {
			trace(entity);
		}
	}
	
}