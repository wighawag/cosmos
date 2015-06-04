package comp.type;

import cosmos.ComponentProvider;
import haxe.DynamicAccess;

class BioType implements ComponentProvider
{
	public var maxLife(default,null) : Int = 0;
	public function new(value : DynamicAccess<Int>) 
	{
		this.maxLife = value["maxLife"];
	}
	
	public function getComponents() : Array<Dynamic> {
		return [new Bio(maxLife)];
	}
	
}