package item.active;

import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxG;
import actors.Player;

class Weapon extends ActiveItem {
	public var damage:Int;
	public var speed:Float;

	public function new(X:Float = 0, Y:Float = 0, Name:String, Damage:Int, Speed:Float) {
		super(X, Y);
		isWeapon = true;
		name = Name;
		loadGraphic("assets/images/active_items/weapons/" + name + ".png", false, 8, 8);
		this.damage = Damage;
		this.speed = Speed;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onUse(P:Player):Bool {
		var playState:PlayState = cast FlxG.state;
		var bullet:Projectile = playState._playerBullets.recycle();
		bullet.reset(P.x + P.width / 2 - bullet.width / 2, P.y);
		bullet.damage = this.damage;
		var mA:Float = 0;
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

		bullet.velocity.set(bullet.flySpeed, 0);
		bullet.velocity.rotate(FlxPoint.weak(0, 0), mA);

		return true;
	}
}
