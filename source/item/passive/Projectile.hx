package item.passive;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxG;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var speed:Float;
	public var lifespan:Float;
	public var damage:Int;
	public var angleOffset:Float = 0;

	public function new(Width:Int, Height:Int) {
		super(0, 0);
		loadGraphic("assets/images/passive_items/projectile.png", false, 8, 8);
		scale = new FlxPoint(Width / this.width, Height / this.height);
		if (!scale.equals(new FlxPoint(1, 1))) {
			updateHitbox();
		}
		exists = false;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		if (lifespan > 0) {
			lifespan -= FlxG.elapsed;

			if (lifespan <= 0) {
				kill();
			}
		}
	}

	public function move(angle:Float):Void {
		this.velocity.set(this.speed, 0);
		this.velocity.rotate(FlxPoint.weak(0, 0), angle + angleOffset);
	}

	public static function collide(Object1:Projectile, Object2:FlxObject):Void {
		Object1.kill();
	}
}
