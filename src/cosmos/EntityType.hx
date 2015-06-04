package cosmos;


@:build(cosmos.macro.EntityTypeMacro.apply("types.json"))
abstract EntityType(GenericEntity) to(GenericEntity)
{
	public function new(entity : GenericEntity) {
		this = entity;	
	}
}