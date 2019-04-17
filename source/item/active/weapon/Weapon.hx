package item.active.weapon;

import actors.brain.Monster;
import flixel.math.FlxAngle;
import actors.Actor;
import flixel.FlxG;
import flixel.util.helpers.FlxBounds;
import item.passive.Projectile;

class Weapon extends ActiveItem {
	public var damage:Int;
	public var speed:Float;
	public var recoilForce:Float;
	public var shotCooldown:Float;
	public var typeOfShooting:String;
	public var bulletsToShoot:Int;
	public var sizeOfBarrel:FlxBounds<Float>;

	public function new(X:Float = 0, Y:Float = 0, name:String, damage:Int, speed:Float, recoilForce:Float, typeOfShooting:String, bulletsToShoot:Int,
			sizeOfBarrel:FlxBounds<Float>) {
		super(X, Y);
		isWeapon = true;
		this.name = name;
		loadGraphic("assets/images/active_items/weapons/" + name + ".png", false, 8, 8);
		this.damage = damage;
		this.speed = speed;
		this.recoilForce = recoilForce;
		this.typeOfShooting = typeOfShooting;
		this.bulletsToShoot = bulletsToShoot;
		this.sizeOfBarrel = sizeOfBarrel;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (shotCooldown < speed) {
			shotCooldown += elapsed;
		}
	}

	override public function onUse(actor:Actor):Bool {
		if (shotCooldown < speed) {
			return false;
		}

		var playState:PlayState = cast FlxG.state;

		for (i in 0...bulletsToShoot) {
			var bullet:Projectile;
			var finalAngle:Float;

			if (actor.isPlayer) {
				bullet = actor.bullets.recycle();
				finalAngle = FlxAngle.angleBetweenMouse(actor, true);
			} else {
				bullet = Monster.sharedBullets.recycle();
				finalAngle = FlxAngle.angleBetween(actor, playState._player, true);
			}

			bullet.speed = recoilForce;
			bullet.damage = damage;
			// bullet.angleOffset = 45;
			if (!bullet.size.equals(sizeOfBarrel)) {
				bullet.changeSize(sizeOfBarrel);
			}
			bullet.reset(actor.x + actor.width / 2, actor.y);
			bullet.owner = owner;

			switch (typeOfShooting) {
				case TypeOfShooting.SHOTGUN:
					finalAngle = (finalAngle - 45) + (90 / (bulletsToShoot - 1) * i);
				case TypeOfShooting.STRAIGHT:
					finalAngle = (360 / bulletsToShoot) * i + finalAngle;
			}

			bullet.move(finalAngle);
		}

		shotCooldown = 0;

		return true;
	}
}
