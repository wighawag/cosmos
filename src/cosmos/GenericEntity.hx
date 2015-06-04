package cosmos;

import belt.ClassMap;

@:allow(cosmos)
class GenericEntity{

	var _components : ClassMap<Class<Dynamic>,Dynamic>;
	public var type(default, null) : GenericEntity;

	private function new(type : GenericEntity, components : Array<Dynamic>) {
		this.type = type;
		_components = new ClassMap();
		for(component in components){
			_components.set(Type.getClass(component), component);
		}
	}

	public function get<T>(componentClass : Class<T>):T{
		return _components.get(componentClass);
	}

	public function has(componentClass : Class<Dynamic>):Bool{
		return _components.exists(componentClass);
	}
}