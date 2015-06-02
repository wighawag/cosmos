package test;

import comp.TestComponent;
import cosmos.System;
import cosmos.Entity;
import cosmos.Updatable;

class TestSystem implements System implements Updatable{

	var dogs : List<Entity<{test:TestComponent}>>;

	public function new(){

	}

	public function update(now : Float, dt : Float){
		trace("dogs");
		for (dog in dogs){
			trace(dog.test.test);
		}
	}

}