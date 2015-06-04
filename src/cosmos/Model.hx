package cosmos;

import belt.ClassMap;
import cosmos.GenericEntity;
import cosmos.Updatable;

class Model implements Updatable{

	var _systems : ClassMap<Class<System>, System>;
	var _updatableSystems : Array<Updatable>;

	var _entities : List<GenericEntity>;

	var _views : Array<ModelFacet<GenericEntity>>;

	public function new(systems : Array<System>){
		_views = new Array();
		_entities = new List();
		_systems = new ClassMap();
		_updatableSystems = new Array();
		for(system in systems){
			if (Std.is(system, Updatable)){
                _updatableSystems.push(cast system);
            }
            _systems.set(Type.getClass(system), system);
		}


		for(system in systems){
			system.model = this;
			system.initialise();
			for (view in system.views){
				_views.push(view);
			}
		}		

		// var failedSystems = initialise(systems);

  //       for (failedSystem in failedSystems){
  //           Report.aWarning(Channels.SYSTEM, "system failed to find its dependencies, it is disabled ", failedSystem);
  //           if (Std.is(failedSystem, Updatable)){
  //               _updatableSystems.remove(cast failedSystem);
  //           }
  //           cast(failedSystem,ModelComponent).model = null;
  //       }
	}

	public function update(now : Float, delta : Float){
		for (system in _updatableSystems){
			system.update(now,delta);
		}
	}

	public function addEntity(components : Array<Dynamic>){
		var newEntity = new GenericEntity(null,components);
		_entities.add(newEntity);
		for(view in _views){
			view.addEntityIfMatch(newEntity);
		}
	}
	
	public function addEntityOfType(entityType : EntityType, components : Array<Dynamic>) {
		var type : GenericEntity = entityType;
		for (typeComponent in type._components) {
			if (Std.is(typeComponent, ComponentProvider)) {
				var provider : ComponentProvider = cast typeComponent;
				components.concat(provider.getComponents());//TODO check duplicates
			}
		}
		var newEntity = new GenericEntity(type,components);
		_entities.add(newEntity);
		for(view in _views){
			view.addEntityIfMatch(newEntity);
		}
	}

	public function removeEntity(entity : GenericEntity){
		_entities.remove(entity);
		for(view in _views){
			view.removeEntity(entity);
		}
	}

	// private function add<T : System>(system :T) : Class<System> {
 //        var systemAccessClass = system.attach(this);
 //        if (systemAccessClass != null){
 //            _systems.set(systemAccessClass, system);
 //        }
 //        return systemAccessClass;
 //    }

	// function initialise(systems : Array<System>) : Array<System>{
	// 	systems = systems.copy();

 //        var systemWithMissingDependencies : System = null;
 //        var lengthAtThatpoint = 0;

 //        var systemsAdded = new ClassMap<Class<System>, Bool>();
 //        for (systemClass in _systems){
 //            systemsAdded.set(systemClass, true);
 //        }
 //        while (systems.length >0){
 //            var system = systems.shift();
 //            var dependenciesFound = true;
 //            if (system.requiredSystems != null){
 //                for (requiredSystem in system.requiredSystems){
 //                    if (!systemsAdded.exists(requiredSystem)){
 //                        dependenciesFound = false;
 //                        systems.push(system); // add back to the end of the list
 //                        if (systemWithMissingDependencies == system && lengthAtThatpoint == systems.length){
 //                            //TODO Report.aWarning(Channels.SYSTEM, "Could not resolved dependencies for ", [systems]);
 //                            trace( "Could not resolved dependencies for ", [systems]);
 //                            return systems;
 //                        }
 //                        if (systemWithMissingDependencies == null){
 //                            systemWithMissingDependencies = system;
 //                            lengthAtThatpoint = systems.length;
 //                        }
 //                        break;
 //                    }
 //                }
 //            }

 //            if (dependenciesFound){
 //                systemWithMissingDependencies = null;
 //                var accessClass = add(component);
 //                system.initialise();
 //                systemsAdded.set(accessClass, true);
 //            }
 //        }

 //        return systems;

	// }

	
}