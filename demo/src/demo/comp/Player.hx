package demo.comp;


class Player
{
	private static var i : Int = 0;
	public var id(default, null) : Int;
	public var isOnFloor : Bool = true;

	public static function instantiateNext() : Player {
		return new Player(++i);
	}
	
	private function new(id : Int) 
	{
		this.id = id;
	}
	
}