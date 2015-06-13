package demo.system;

import demo.comp.FlameComponent;
import demo.comp.Placement;
import demo.comp.TestComponent;
import demo.comp.type.BioType;
import cosmos.System;
import cosmos.Entity;
import cosmos.Entities;

class TestSystem implements System{
	
	var set1 : Entities<{test:TestComponent}>;
	var set2 : Entities<{flame:FlameComponent}>;
	var set3 : Entities<{test:TestComponent,flame:FlameComponent, type:{flame:FlameComponent}}>;
	
	@:onAdded(entityAddedToSet4)
	@:onRemoved(entityRemovedFromSet4)
	var set4 : Entities<{type:{bioType:BioType}}>;
	
	var set5 : Entities<{placement:Placement}>;
	
	function entityAddedToSet4(entity) {
		trace("added : ", entity);
	}
	
	function entityRemovedFromSet4(entity) {
		trace("removed : ", entity);
	}

	function update(now : Float, dt : Float){
		trace("set1");
		for (entity in set1){
			trace(entity.test.value);
			//model.removeEntity(entity);

		}
		trace("set2");
		for (entity in set2){
			trace(entity.flame.flame);
		}
		trace("set3");
		for (entity in set3){
			trace(entity.test.value + ", " + entity.flame.flame);
			trace(entity.type.flame.flame);
		}
		trace("set4");
		for (entity in set4){
			trace(entity.type.bioType.maxLife);
			trace(entity.type.id);
			model.removeEntity(entity);
		}
		trace("set5");
		for (entity in set5){
			trace(entity.placement);
		}
		
		
	}

}