package demo;

import cosmos.CosmosPresenter;
import cosmos.Model;
import demo.system.NapeSystem;
import demo.system.Populator;
import demo.view.CanvasPresenter;
import haxe.Timer;
import js.Browser;
import js.html.CanvasElement;

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
		
		model = new Model([new NapeSystem(canvasElement.clientWidth, canvasElement.clientHeight), new Populator()]);
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