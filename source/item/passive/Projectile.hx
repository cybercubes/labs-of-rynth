package item.passive;

import actors.Actor;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.helpers.FlxBounds;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var speed:Float;
	public var lifespan:Float;
	public var damage:Int;
	public var originalSize:FlxBounds<Int> = new FlxBounds<Int>(8, 8);
	public var size:FlxBounds<Float>;
	public var angleOffset:Float = 0;

	public function new() {
		super(0, 0);
		loadGraphic("assets/images/passive_items/projectile.png", false, originalSize.min, originalSize.max);
		size = new FlxBounds<Float>(width, height);
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

		var playState:PlayState = cast FlxG.state;
		FlxG.collide(this, playState._mWalls, collide);

		if (owner.isPlayer) {
			FlxG.overlap(this, playState._monsterS, Actor.takeDamage);
		} else {
			FlxG.overlap(this, playState._player, Actor.takeDamage);
		}
	}

	public function move(angle:Float):Void {
		this.velocity.set(this.speed, 0);
		this.velocity.rotate(FlxPoint.weak(0, 0), angle + angleOffset);
	}

	public function changeSize(SizeOfBarrel:FlxBounds<Float>) {
		scale = new FlxPoint(SizeOfBarrel.min / size.min, SizeOfBarrel.max / size.max);
		updateHitbox();
	}

	function collide(Object1:Projectile, Object2:FlxObject):Void {
		Object1.kill();
	}
}
