package test;

import comp.TestComponent;
import cosmos.System;
import cosmos.Entity;
import cosmos.Entities;
import cosmos.Updatable;

class TestSystem implements System implements Updatable{

	var set1 : Entities<{test:TestComponent}>;
	var set2 : Entities<{test:TestComponent}>;


	public function update(now : Float, dt : Float){
		trace("set1");
		for (entity in set1){
			trace(entity.test.test);
		}
		trace("set2");
		for (entity in set2){
			trace(entity.test.test);
		}
	}

}