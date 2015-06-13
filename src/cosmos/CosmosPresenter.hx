package cosmos;

import cosmos.GenericEntity;
import cosmos.ModelFacet;

@:allow(cosmos.Model)
@:autoBuild(cosmos.macro.SystemMacro.apply())
interface CosmosPresenter { //TODO remove start/update
	private var updatable : Bool;
	private var views : Array<ModelFacet<GenericEntity>>; //TODO private if possible ?
	private var model : ModelData; //TODO private if possible?
	private function _init():Void;
	private function start(now : Float):Void;
	private function update(now : Float, delta : Float):Void;
}