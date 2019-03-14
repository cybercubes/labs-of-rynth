package item.passive;

import item.active.weapon.TypeOfShooting;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import actors.Player;
import flixel.FlxG;
import flixel.util.helpers.FlxBounds;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var speed:Float;
	public var lifespan:Float;
	public var damage:Int;
	public var size:FlxBounds<Int>;

	public function new(Size:FlxBounds<Int>) {
		super(0, 0);
		loadGraphic("assets/images/passive_items/projectile.png", false, 8, 8);
		scale = new FlxPoint(0.5, 0.5);
		updateHitbox();
		this.size = Size;
		// makeGraphic(Size.min, Size.max, FlxColor.RED);

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

	public function move(P:Player, typeOfShooting:String):Void {
		var mA:Float = 0;

		if (typeOfShooting == TypeOfShooting.STRAIGHT) {
			if (P.facing == FlxObject.UP) {
				mA = -90;
				if (P.goesLeft)
					mA -= 45;
				else if (P.goesRight)
					mA += 45;
			} else if (P.facing == FlxObject.DOWN) {
				mA = 90;
				if (P.goesLeft)
					mA += 45;
				else if (P.goesRight)
					mA -= 45;
			} else if (P.facing == FlxObject.LEFT) {
				mA = 180;
			} else if (P.facing == FlxObject.RIGHT) {
				mA = 0;
			}
		}

		this.velocity.set(this.speed, 0);
		this.velocity.rotate(FlxPoint.weak(0, 0), mA);
	}
}
