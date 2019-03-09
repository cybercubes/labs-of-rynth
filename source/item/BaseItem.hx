package item;

import actors.Player;
import flixel.FlxSprite;

class BaseItem extends FlxSprite {
	public var isActive:Bool;
	public var isWeapon:Bool;
	public var name:String;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X + 4, Y + 4);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	public function onUse(P:Player):Bool {
		return true;
	}
}
