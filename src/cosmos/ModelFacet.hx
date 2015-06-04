package cosmos;

import cosmos.GenericEntity;

class ModelFacet<T>{
	var list : List<T>;

	private var componentClasses : Array<Class<Dynamic>>;
	private var typeComponentClasses : Array<Class<Dynamic>>;

	public function new(componentClasses : Array<Class<Dynamic>>, typeComponentClasses : Array<Class<Dynamic>>){
		list = new List();
		this.componentClasses = componentClasses.copy();
		this.typeComponentClasses = typeComponentClasses.copy();
	}

	inline public function iterator() {
		return list.iterator();
	}

	public function addEntityIfMatch(entity : GenericEntity) : Bool{
		for(componentClass in componentClasses){
			if(!entity.has(componentClass)){
				return false;
			}
		}
		
		for(componentClass in typeComponentClasses){
			if(entity.type == null || !entity.type.has(componentClass)){
				return false;
			}
		}
		list.add(cast entity);
		return true;
	}

	public function removeEntity(entity : GenericEntity){
		list.remove(cast entity);
	}
}