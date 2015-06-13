package demo.comp;
import nape.phys.Body;
import nape.shape.Shape;

class NapeBody
{
	public var body(default, null) : Body;
	public function new(body : Body) 
	{
		this.body = body;
	}
	
}