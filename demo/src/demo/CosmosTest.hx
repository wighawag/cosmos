package demo;

import control.Input;
import cosmos.CosmosPresenter;
import cosmos.Model;
import demo.system.Controller;
import demo.system.NapeSystem;
import demo.system.Populator;
import demo.view.CanvasPresenter;
import haxe.Timer;
import js.Browser;
import js.html.CanvasElement;
import nape.geom.Vec2;
import nape.space.Space;

class CosmosTest{
	public static function main(){
		new CosmosTest();
	}
	
	var model : Model;
	var presenter : CanvasPresenter;
	var lastTime : Float;
	
	function new() {
		var canvasElement : CanvasElement = cast Browser.document.getElementById("canvas");
		trace(canvasElement.clientWidth, canvasElement.clientHeight);
		presenter = new CanvasPresenter(canvasElement);
		
		var gravity:Vec2 = new Vec2(0, -600); 
		var space = new Space(gravity);
		
		model = new Model([new Controller(Input.initKeyboard(),space,canvasElement.clientWidth, canvasElement.clientHeight), new NapeSystem(space), new Populator()]);
		model.setupPresenter(presenter);
		
		lastTime = Timer.stamp();
		model.start(lastTime);
		Browser.window.requestAnimationFrame(update);
	}
	
	function update(d){
		var now = Timer.stamp();
		var delta = now - lastTime;
		lastTime = now;
		model.update(now, delta);
		
		presenter.present(now);
		Browser.window.requestAnimationFrame(update);
	}
}