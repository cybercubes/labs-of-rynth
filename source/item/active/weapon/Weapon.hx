package item.active.weapon;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxAngle;
import actors.Actor;
import flixel.FlxG;
import item.passive.Projectile;

class Weapon extends ActiveItem {
	public var damage:Int;
	public var speed:Float;
	public var recoilForce:Float;
	public var shotCooldown:Float;
	public var typeOfShooting:String;
	public var numOfBulletsToShoot:Int;
	public var bulletsToUse:FlxTypedGroup<Projectile>;
	public var spread:Int;

	public function new(X:Float = 0, Y:Float = 0, name:String, damage:Int, speed:Float, recoilForce:Float, typeOfShooting:String, numOfBulletsToShoot:Int,
			bulletsToUse:FlxTypedGroup<Projectile>, spread:Int = 360) {
		super(X, Y);
		isWeapon = true;
		this.name = name;
		loadGraphic("assets/images/active_items/weapons/" + name + ".png", false, 8, 8);
		this.damage = damage;
		this.speed = speed;
		this.recoilForce = recoilForce;
		this.typeOfShooting = typeOfShooting;
		this.numOfBulletsToShoot = numOfBulletsToShoot;
		this.bulletsToUse = bulletsToUse;
		this.spread = spread;
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

		for (i in 0...numOfBulletsToShoot) {
			var bullet:Projectile;
			var finalAngle:Float;
			var playState:PlayState = cast FlxG.state;
			bullet = bulletsToUse.recycle();

			if (actor.isPlayer) {
				finalAngle = FlxAngle.angleBetweenMouse(actor, true);
				for (monster in playState._monsterS)
				{
					bullet.setTarget(monster);
					bullet.setStartAngle(finalAngle);
				}
			} else {
				finalAngle = FlxAngle.angleBetween(actor, playState._player, true);
				bullet.setTarget(playState._player);
				bullet.setStartAngle(finalAngle);
			}

			bullet.speed = recoilForce;
			bullet.damage = damage;
			bullet.reset(actor.x + actor.width / 2, actor.y);
			bullet.owner = owner;

			if (numOfBulletsToShoot != 1) {
				switch (typeOfShooting) {
					case TypeOfShooting.STRAIGHT:
						finalAngle = (finalAngle - (spread / 2)) + (spread / (numOfBulletsToShoot - 1) * i);
				}
			}

			bullet.setAngle(finalAngle);
		}

		shotCooldown = 0;

		return true;
	}
}
