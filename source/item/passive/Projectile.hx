package item.passive;

import actors.Actor;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.util.helpers.FlxBounds;
import item.passive.PassiveItem;
import utils.MathUtils;
import enums.Trajectories;

class Projectile extends PassiveItem {
	public var _startAngle:Float;
	public var _angle:Float = 0; //current direction of the projectile in question
	public var _target:Actor; //target for the homing trajectory towards which the bullet will adjust its angle

	public var speed:Float;
	public var lifespan:Float;
	public var damage:Int;
	public var originalSize:FlxBounds<Int> = new FlxBounds<Int>(8, 8);
	public var size:FlxBounds<Float>;
	public var angleOffset:Float = 0;
	public var trajectory:String = Trajectories.BURST;

	public function new() {
		super(0, 0);
		loadGraphic("assets/images/passive_items/projectile.png", false, originalSize.min, originalSize.max);
		size = new FlxBounds<Float>(width, height);
		exists = false;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		
		updatePos();

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

	public function changeSize(SizeOfBarrel:FlxBounds<Float>) {
		scale = new FlxPoint(SizeOfBarrel.min / size.min, SizeOfBarrel.max / size.max);
		updateHitbox();
	}

	function collide(Object1:Projectile, Object2:FlxObject):Void {
		Object1.kill();
	}

	function updatePos():Void {
		switch (trajectory) {
			case Trajectories.STRAIGHT:
				this.x = this.x + Math.cos(MathUtils.toRads(_angle)) * speed;
				this.y = this.y + Math.sin(MathUtils.toRads(_angle)) * speed;
			case Trajectories.BURST:
				_angle = _angle + 4; //TODO: change the hardcoded value to a variable that will decide how quick the bullets will rotate
				this.x = this.x + (Math.cos(MathUtils.toRads(_angle)) + Math.cos(MathUtils.toRads(_startAngle))) * speed;
				this.y = this.y + (Math.sin(MathUtils.toRads(_angle)) + Math.sin(MathUtils.toRads(_startAngle))) * speed;
			case Trajectories.TURN:
				_angle = _angle + 4; //TODO: change the hardcoded value to a variable that will decide how quick the bullets will rotate
				this.x = this.x + Math.cos(MathUtils.toRads(_angle)) * speed;
				this.y = this.y + Math.sin(MathUtils.toRads(_angle)) * speed;
		}
    }

	public function setAngle(angle:Float):Void {
		_angle = angle;
	}

	public function setStartAngle(angle:Float):Void {
		_startAngle = angle;
	}

	public function setTarget(target:Actor):Void
	{
		_target = target;
	}

	public function getAngle():Float
	{
		return _angle;
	}
}
