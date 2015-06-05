package cosmos;


@:build(cosmos.macro.EntityTypeMacro.apply())
abstract EntityType(GenericEntity) to(GenericEntity)
{
	public function new(entity : GenericEntity) {
		this = entity;	
	}
}