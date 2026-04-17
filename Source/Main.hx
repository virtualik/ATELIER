package;

import openfl.display.Sprite;
import openfl.display.Shape;

class Main extends Sprite {
	public function new() {
		super();
		
		var square = new Shape();
		square.graphics.beginFill(0xFF0000); // Красный цвет
		square.graphics.drawRect(0, 0, 100, 100);
		square.graphics.endFill();
		
		square.x = 50;
		square.y = 50;
		addChild(square);
	}
}