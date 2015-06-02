package test;

import comp.TestComponent;
import cosmos.System;
import cosmos.Entity;

class TestSystem implements System{

	var dogs : List<Entity<{a:TestComponent}>>;

	public function new(){

	}

	function update(now : Float, dt : Float){
		for (dog in dogs){
			dog.getTestComponent().test();
		}
	}

}