package comp.type;
import cosmos.ComponentProvider;
import haxe.DynamicAccess;

class Provider implements ComponentProvider
{
	var componentClasses : Array<Class<Dynamic>>;
	var componentArguments : Array<Dynamic>;
	
	public function new(components : DynamicAccess<Array<Dynamic>>) 
	{
		componentClasses = new Array();
		componentArguments = new Array();
		for (componentClassPath in components.keys()) {
			componentClasses.push(Type.resolveClass(componentClassPath));
			componentArguments.push(components[componentClassPath]);
		}
	}
	
	public function getComponents():Array<Dynamic> 
	{
		var newComponents = [];
		for (i in 0...componentClasses.length) {
			newComponents.push(Type.createInstance(componentClasses[i],componentArguments[i]));
		}
		return newComponents;
	}
	
}