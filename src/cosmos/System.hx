package cosmos;

import cosmos.GenericEntity;

@:autoBuild(cosmos.macro.SystemMacro.apply())
interface System{
	public var views : Array<List<GenericEntity>>; //TODO private if possible ?
	public var model : Model; //TODO private if possible?
	function initialise():Void;
}