package cosmos;

@:allow(cosmos)
class GenericEntity{

	private function new(){

	}

	public function get<T>(componentClass : Class<T>):T{
		return null; //TODO 
	}
}