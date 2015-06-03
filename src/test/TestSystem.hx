package test;

import comp.FlameComponent;
import comp.TestComponent;
import cosmos.System;
import cosmos.Entity;
import cosmos.Entities;
import cosmos.Updatable;

class TestSystem implements System implements Updatable{

	var set1 : Entities<{test:TestComponent}>;
	var set2 : Entities<{flame:FlameComponent}>;
	var set3 : Entities<{test:TestComponent,flame:FlameComponent}>;


	public function update(now : Float, dt : Float){
		trace("set1");
		for (entity in set1){
			trace(entity.test.test);
			//model.removeEntity(entity);

		}
		trace("set2");
		for (entity in set2){
			trace(entity.flame.flame);
		}
		trace("set3");
		for (entity in set3){
			trace(entity.test.test + ", " + entity.flame.flame);
		}
	}

}