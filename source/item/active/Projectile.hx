package item.active;

import flixel.util.FlxColor;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var flySpeed:Float = 100;
	public var damage:Int;

	var lifespan:Float;

	public function new() {
		super(0, 0);
		// loadGraphic("assets/images/passive_items/projectile.png", false, 8, 8);
		makeGraphic(4, 4, FlxColor.RED);

		exists = false;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
