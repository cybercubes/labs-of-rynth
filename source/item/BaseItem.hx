package item;

import flixel.FlxSprite;

class BaseItem extends FlxSprite {
	public var isActive:Bool;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X + 4, Y + 4);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

}
