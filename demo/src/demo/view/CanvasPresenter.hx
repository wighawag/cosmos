package demo.view;
import cosmos.CosmosPresenter;
import cosmos.Entities;
import demo.comp.NapeBody;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;


class CanvasPresenter implements CosmosPresenter
{

	var set1 : Entities<{nape:NapeBody}>;
	
	var canvas : CanvasRenderingContext2D;
	var canvasElement : CanvasElement;
	
	public function new(canvasElement : CanvasElement) {
		this.canvasElement = canvasElement;
		canvas = canvasElement.getContext2d();
	}
	
	public function present(now : Float) {
		// Lookup the size the browser is displaying the canvas.
		var displayWidth  = canvasElement.clientWidth;
		var displayHeight = canvasElement.clientHeight;

		// Check if the canvas is not the same size.
		if (canvasElement.width  != displayWidth ||
			canvasElement.height != displayHeight) {

			// Make the canvas the same size
			canvasElement.width  = displayWidth;
			canvasElement.height = displayHeight;
		}
  
		canvas.clearRect(0, 0, canvasElement.clientWidth, canvasElement.clientHeight);
		for (entity in set1) {
			canvas.beginPath();
			canvas.arc(canvasElement.clientWidth - entity.nape.body.position.x, canvasElement.clientHeight - entity.nape.body.position.y, entity.nape.body.bounds.width/2, 0, 2 * Math.PI, false);
			canvas.fillStyle = 'green';
			canvas.fill();
			canvas.lineWidth = 5;
			canvas.strokeStyle = '#003300';
			canvas.stroke();
		}
	}
	
}