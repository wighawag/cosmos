package demo.view;
import cosmos.CosmosPresenter;
import cosmos.Entities;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import nape.phys.Body;
import nape.shape.Circle;


class CanvasPresenter implements CosmosPresenter
{

	var set1 : Entities<{body:Body}>;
	
	var canvas : CanvasRenderingContext2D;
	var canvasElement : CanvasElement;
	
	public function new(canvasElement : CanvasElement) {
		this.canvasElement = canvasElement;
		canvas = canvasElement.getContext2d();
	}
	
	public function present(now : Float) {
		var displayWidth  = canvasElement.clientWidth;
		var displayHeight = canvasElement.clientHeight;
		if (canvasElement.width  != displayWidth || canvasElement.height != displayHeight) {
			canvasElement.width  = displayWidth;
			canvasElement.height = displayHeight;
		}
  
		canvas.clearRect(0, 0, canvasElement.clientWidth, canvasElement.clientHeight);
		for (entity in set1) {
			for (shape in entity.body.shapes) {
				if (Std.is(shape,Circle)) {
					var circle : Circle = cast shape;
					canvas.beginPath();
					canvas.arc(canvasElement.clientWidth - entity.body.position.x, canvasElement.clientHeight - entity.body.position.y, circle.radius, 0, 2 * Math.PI, false);
					canvas.fillStyle = 'green';
					canvas.fill();
					canvas.lineWidth = 5;
					canvas.strokeStyle = '#003300';
					canvas.stroke();
				}
			}
			
		}
	}
	
}