package test;

import comp.TestComponent;
import cosmos.System;


class Populator implements System{

	public function new(){

	}

	public function initialise(){
		trace("Populator");
		model.addEntity([new TestComponent("hello")]);
		model.addEntity([new TestComponent("hello2")]);
	}

}