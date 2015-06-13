package demo.system;

import cosmos.EntityType;
import cosmos.System;
import demo.comp.NapeBody;
import nape.phys.Body;
import nape.phys.Material;
import nape.shape.Circle;
using cosmos.ModelAccess;


class Populator implements System{

	public function start(now : Float) {
		var circle:Circle = new Circle(30); // local position argument is optional.
		circle.material = Material.rubber();
		var circleBody:Body = new Body(); // Implicit BodyType.DYNAMIC
		circleBody.shapes.add(circle);
		circleBody.position.setxy(500, 500);
		
		model.addEntity([new NapeBody(circleBody)]);
		
	}

}