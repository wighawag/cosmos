package comp.type;
import cosmos.ComponentProvider;

class Provider implements ComponentProvider
{
	var componentClasses : Array<Class<Dynamic>>;
	
	public function new(componentClassPaths : Array<String>) 
	{
		componentClasses = new Array();
		for (componentClassPath in componentClassPaths) {
			componentClasses.push(Type.resolveClass(componentClassPath));
		}
	}
	
	public function getComponents():Array<Dynamic> 
	{
		var newComponents = [];
		for (componentClass in componentClasses) {
			newComponents.push(Type.createInstance(componentClass,[]));
		}
		return newComponents;
	}
	
}