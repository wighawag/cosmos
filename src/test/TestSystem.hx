package test;

import comp.FlameComponent;
import comp.Placement;
import comp.TestComponent;
import comp.type.BioType;
import cosmos.System;
import cosmos.Entity;
import cosmos.Entities;

class TestSystem implements System{
	
	var set1 : Entities<{test:TestComponent}>;
	var set2 : Entities<{flame:FlameComponent}>;
	var set3 : Entities<{test:TestComponent,flame:FlameComponent, type:{flame:FlameComponent}}>;
	var set4 : Entities<{type:{bioType:BioType}}>;
	var set5 : Entities<{placement:Placement}>;

	function initialise() {
		set4.onEntityAdded(entityAddedToSet4);
	}
	
	function entityAddedToSet4(entity) {
		trace(entity);
	}

	function update(now : Float, dt : Float){
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
			trace(entity.type.flame.flame);
		}
		trace("set4");
		for (entity in set4){
			trace(entity.type.bioType.maxLife);
			trace(entity.type.id);
		}
		trace("set5");
		for (entity in set5){
			trace(entity.placement);
		}
	}

}