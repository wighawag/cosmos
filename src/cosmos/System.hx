package cosmos;

import cosmos.GenericEntity;
import cosmos.ModelFacet;

@:allow(cosmos.Model)
@:autoBuild(cosmos.macro.SystemMacro.apply())
interface System {
	private var updatable : Bool;
	private var views : Array<ModelFacet<GenericEntity>>; //TODO private if possible ?
	private var model : ModelData; //TODO private if possible?
	private function initialise():Void;
	private function update(now : Float, delta : Float):Void;
}