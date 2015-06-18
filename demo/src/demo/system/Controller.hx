package demo.system;
import control.Keyboard;
import cosmos.Entities;
import cosmos.Entity;
import cosmos.System;
import demo.comp.Player;
import loka.input.Key;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.space.Space;

class Controller implements System
{
	
	var PLAYER = new CbType();
	var FLOOR = new CbType();

	@:onAdded(playerAdded)
	var players : Entities<{player:Player, body : Body}>;
	
	var keyboard:Keyboard;
	var space:Space;
	
	function playerAdded(entity : Entity<{player:Player, body : Body}>) {
		//TODO support multiple player
		entity.body.cbTypes.add(PLAYER);
		var interactionListener = new InteractionListener(CbEvent.BEGIN,InteractionType.COLLISION,FLOOR,PLAYER,playerToFloor);
		space.listeners.add(interactionListener);
		var interactionListener = new InteractionListener(CbEvent.END,InteractionType.COLLISION,FLOOR,PLAYER,playerToFloorEnd);
		space.listeners.add(interactionListener);
	}
	
	function playerToFloor(collision:InteractionCallback):Void {
		for (entity in players) {
			entity.player.isOnFloor = true;
		}
	}
	
	function playerToFloorEnd(collision:InteractionCallback):Void {
		for (entity in players) {
			entity.player.isOnFloor = false;
		}
	}
		
	public function new(keyboard : Keyboard, space : Space, width : Float, height : Float) 
	{
		this.keyboard = keyboard;
		this.space = space;
		
		trace("width :" + width);
		
		var floorBody:Body = new Body(BodyType.STATIC);
		var floorShape:Polygon = new Polygon(Polygon.rect(0, 0, width, 1));
		floorBody.cbTypes.add(FLOOR);
		floorBody.shapes.add(floorShape);
		space.bodies.add(floorBody);	
		
	}
	
	public function start(now : Float) {
		
	}
	
	public function update(now : Float, delta : Float) {
		for (entity in players) {
			if (entity.player.id == 1) {
				if (keyboard.isDown(Key.SPACE) && entity.player.isOnFloor) {
					trace("space");
					//TODO check if body is on top of floor if(entity.body.
					entity.body.applyImpulse(Vec2.get(0, 600));
				}
			}
			
		}
	}
	
}