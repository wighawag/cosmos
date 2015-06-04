package cosmos;

import cosmos.GenericEntity;
import cosmos.ModelFacet;

@:autoBuild(cosmos.macro.SystemMacro.apply())
interface System {
	public var views : Array<ModelFacet<GenericEntity>>; //TODO private if possible ?
	public var model : ModelData; //TODO private if possible?
	function initialise():Void;
}