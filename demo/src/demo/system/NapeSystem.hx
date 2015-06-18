package demo.system;
import cosmos.Entities;
import cosmos.Entity;
import cosmos.System;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

class NapeSystem implements System
{
	
	@:onAdded(napeShapeAdded)
	@:onRemoved(napeShapeRemoved)
	var napeShapes : Entities<{body:Body}>;
	
	var space : Space;
	
	public function new(space : Space) {
		this.space = space;			
	}

	function napeShapeAdded(entity : Entity<{body:Body}>) {
		space.bodies.add(entity.body);
	}
	
	function napeShapeRemoved(entity : Entity<{body:Body}>) {
		space.bodies.remove(entity.body);
	}
	

	
	public function update(now :Float, delta : Float) {
		space.step(delta);
	}
	
}