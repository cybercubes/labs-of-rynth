package item.passive;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.helpers.FlxBounds;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var speed:Float;
	public var lifespan:Float;
	public var damage:Int;
	public var originalSize:FlxBounds<Int> = new FlxBounds<Int>(8, 8);

	public function new() {
		super(0, 0);
		loadGraphic("assets/images/passive_items/projectile.png", false, originalSize.min, originalSize.max);
		scale = new FlxPoint(0.5, 0.5);
		updateHitbox();

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

	public function move(angle:Float):Void {
		this.velocity.set(this.speed, 0);
		this.velocity.rotate(FlxPoint.weak(0, 0), angle);
	}

	public function changeSize(SizeOfBarrel:FlxBounds<Int>) {
		scale = new FlxPoint(SizeOfBarrel.min / graphic.width, SizeOfBarrel.max / graphic.height);
		updateHitbox();
	}
}
