package item;

import flixel.FlxSprite;

class BaseItem extends FlxSprite {
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
