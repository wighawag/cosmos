package test;

import comp.TestComponent;
import cosmos.Entities;
import cosmos.System;

class TestSystem implements System{

	var dogs : Entities<{a:TestComponent}>;

	public function new(){

	}

	function update(now : Float, dt : Float){
		for (dog in dogs){
			dog.get(TestComponent).test();
		}
	}



}