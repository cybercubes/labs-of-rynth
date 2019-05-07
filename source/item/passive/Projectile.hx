package item.passive;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxG;
import item.passive.PassiveItem;
import utils.MathUtils;
import enums.Trajectories;
import actors.Actor;

class Projectile extends PassiveItem {
	public var _startAngle:Float;
	public var _angle:Float = 0; //current direction of the projectile in question
	public var _target:Actor; //target for the homing trajectory towards which the bullet will adjust its angle
	public var _trajectory:String;

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
		
		updatePos();

		if (lifespan > 0) {
			lifespan -= FlxG.elapsed;

			if (lifespan <= 0) {
				kill();
			}
		}
	}

	function updatePos():Void {
		switch (_trajectory) {
			case Trajectories.STRAIGHT:
				this.x = this.x + Math.cos(MathUtils.toRads(_angle)) * speed;
				this.y = this.y + Math.sin(MathUtils.toRads(_angle)) * speed;
			case Trajectories.BURST:
				_angle = _angle + 4; //TODO: change the hardcoded value to a variable that will decide how quick the bullets will rotate
				this.x = this.x + (Math.cos(MathUtils.toRads(_angle)) + Math.cos(MathUtils.toRads(_startAngle))) * speed;
				this.y = this.y + (Math.sin(MathUtils.toRads(_angle)) + Math.sin(MathUtils.toRads(_startAngle))) * speed;
			case Trajectories.TURN:
				_angle = _angle + 1; //TODO: change the hardcoded value to a variable that will decide how quick the bullets will rotate
				this.x = this.x + Math.cos(MathUtils.toRads(_angle)) * speed;
				this.y = this.y + Math.sin(MathUtils.toRads(_angle)) * speed;
		}
    }

	public static function collide(Object1:Projectile, Object2:FlxObject):Void {
        Object1.kill();
    }

	public function setAngle(angle:Float):Void {
		_angle = angle;
	}

	public function setStartAngle(angle:Float):Void {
		_startAngle = angle;
	}
	
	public function setTrajectory(trajectory:String):Void {
		_trajectory = trajectory;
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
