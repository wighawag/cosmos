package demo.system;
import cosmos.Entities;
import cosmos.Entity;
import cosmos.System;
import demo.comp.NapeBody;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

class NapeSystem implements System
{
	
	@:onAdded(napeShapeAdded)
	@:onRemoved(napeShapeRemoved)
	var napeShapes : Entities<{nape:NapeBody}>;
	
	var space : Space;
	
	public function new(width : Float, height : Float) {
		var gravity:Vec2 = new Vec2(0, -600); // units are pixels/second/second
		space = new Space(gravity);	
		var floorBody:Body = new Body(BodyType.STATIC);
		var floorShape:Polygon = new Polygon(Polygon.rect(0, 0, width, 1));
		floorBody.shapes.add(floorShape);
		space.bodies.add(floorBody);
	}

	function napeShapeAdded(entity : Entity<{nape:NapeBody}>) {
		space.bodies.add(entity.nape.body);
	}
	
	function napeShapeRemoved(entity : Entity<{nape:NapeBody}>) {
		space.bodies.remove(entity.nape.body);
	}
	
	public function start(now :Float) {
		
	}
	
	public function update(now :Float, delta : Float) {
		space.step(delta);
	}
	
}