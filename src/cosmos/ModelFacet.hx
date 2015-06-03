package cosmos;

import cosmos.GenericEntity;

class ModelFacet<T>{
	var list : List<T>;

	private var componentClasses : Array<Class<Dynamic>>;

	public function new(componentClasses : Array<Class<Dynamic>>){
		list = new List();
		this.componentClasses = componentClasses.copy();
	}

	public function iterator() {
		return list.iterator();
	}

	public function addEntityIfMatch(entity : GenericEntity) : Bool{
		for(componentClass in componentClasses){
			if(!entity.has(componentClass)){
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