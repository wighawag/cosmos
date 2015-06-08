package cosmos;


@:build(cosmos.macro.EntityTypeMacro.apply())
abstract EntityType(GenericEntityType) to(GenericEntityType)
{
	public function new(type : GenericEntityType) {
		this = type;	
	}
}