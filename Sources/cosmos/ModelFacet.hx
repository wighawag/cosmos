package cosmos;

import cosmos.GenericEntity;

@:allow(cosmos.Model)
class ModelFacet<T> {
	var onAddedFunc : T ->Void;
	var onRemovedFunc : T ->Void;
	var list : List<T>;

	private var componentClasses : Array<Class<Dynamic>>;
	private var typeComponentClasses : Array<Class<Dynamic>>;

	public function new(componentClasses : Array<Class<Dynamic>>, typeComponentClasses : Array<Class<Dynamic>>){
		list = new List();
		this.componentClasses = componentClasses.copy();
		this.typeComponentClasses = typeComponentClasses.copy();
	}
	
	private function onEntityAdded(func : T->Void) {
		this.onAddedFunc = func;
	}
	
	private function onEntityRemoved(func : T->Void) {
		this.onRemovedFunc = func;
	}

	inline public function iterator() {
		return list.iterator();
	}

	private function addEntityIfMatch(entity : GenericEntity) : Bool {
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
		var theEntity : T = cast entity;
		list.add(theEntity);
		if (onAddedFunc != null) {
			onAddedFunc(theEntity);
		}
		return true;
	}

	private function removeEntity(entity : GenericEntity){
		list.remove(cast entity);
		if (onRemovedFunc != null) {
			onRemovedFunc(cast entity);
		}
	}
}