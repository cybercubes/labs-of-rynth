package item.passive;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.helpers.FlxBounds;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var flySpeed:Float;
	public var damage:Int;
	public var lifespan:Float;
	public var size:FlxBounds<Int>;

	public function new(Size:FlxBounds<Int>, FlySpeed:Float) {
		super(0, 0);
		// loadGraphic("assets/images/passive_items/projectile.png", false, 8, 8);
		this.size = Size;
		makeGraphic(Size.min, Size.max, FlxColor.RED);
		this.flySpeed = FlySpeed;

		exists = false;
	}

	override public function update(elapsed:Float):Void {
		if (lifespan > 0) {
			lifespan -= FlxG.elapsed;

			if (lifespan <= 0) {
				kill();
			}
		}
		super.update(elapsed);
	}
}
