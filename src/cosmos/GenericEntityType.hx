package cosmos;

import belt.ClassMap;

@:allow(cosmos)
class GenericEntityType{

	var _components : ClassMap<Class<Dynamic>,Dynamic>;
	public var id(default,null) : String;

	private function new(id : String, components : Array<Dynamic>) {
		this.id = id;
		_components = new ClassMap();
		for (component in components) {
			var clazz = Type.getClass(component);
			if (!_components.exists(clazz)){	
				_components.set(clazz, component);
			}
		}
	}

	public function get<T>(componentClass : Class<T>):T{
		return _components.get(componentClass);
	}

	public function has(componentClass : Class<Dynamic>):Bool{
		return _components.exists(componentClass);
	}
}
