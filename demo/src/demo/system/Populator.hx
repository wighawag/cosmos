package demo.system;

import demo.comp.Placement;
import demo.comp.TestComponent;
import demo.comp.FlameComponent;
import cosmos.EntityType;
import cosmos.System;
using cosmos.ModelAccess;


class Populator implements System{

	public function start(now : Float){
		trace("Populator");
		model.addEntity([new TestComponent("hello")]);
		model.addEntity([new TestComponent("hello2")]);
		model.addEntity([new FlameComponent(1)]);
		model.addEntity([new TestComponent("both"), new FlameComponent(2)]);	
		
		model.addEntityOfType(EntityType.DOG, [new TestComponent("DOG")]);
		
	}

}