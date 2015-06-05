package cosmos;


@:build(cosmos.macro.EntityTypeMacro.apply("types.json")) //TODO get types.json form compiler, if not found do not use types
abstract EntityType(GenericEntity) to(GenericEntity)
{
	public function new(entity : GenericEntity) {
		this = entity;	
	}
}