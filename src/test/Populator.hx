package test;

import comp.TestComponent;
import comp.FlameComponent;
import cosmos.System;


class Populator implements System{

	public function initialise(){
		trace("Populator");
		model.addEntity([new TestComponent("hello")]);
		model.addEntity([new TestComponent("hello2")]);
		model.addEntity([new FlameComponent(1)]);
		model.addEntity([new TestComponent("both"),new FlameComponent(2)]);

	}

}