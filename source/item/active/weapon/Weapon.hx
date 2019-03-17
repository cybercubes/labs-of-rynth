package item.active.weapon;

import flixel.math.FlxAngle;
import flixel.system.debug.console.ConsoleUtil;
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
	public var sizeOfBarrel:FlxBounds<Int>;

	public function new(X:Float = 0, Y:Float = 0, Name:String, Damage:Int, Speed:Float, RecoilForce:Float, typeOfShooting:String, bulletsToShoot:Int,
			SizeOfBarrel:FlxBounds<Int>) {
		super(X, Y);
		isWeapon = true;
		name = Name;
		loadGraphic("assets/images/active_items/weapons/" + name + ".png", false, 8, 8);
		this.damage = Damage;
		this.speed = Speed;
		this.recoilForce = RecoilForce;
		this.typeOfShooting = typeOfShooting;
		this.bulletsToShoot = bulletsToShoot;
		this.sizeOfBarrel = SizeOfBarrel;
	}

	override public function update(elapsed:Float):Void {
		if (shotCooldown < speed) {
			shotCooldown += elapsed;
		}
		super.update(elapsed);
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
				bullet = playState._playerBullets.recycle();
				finalAngle = actor.mA;
			} else {
				bullet = playState._enemyBullets.recycle();
				finalAngle = FlxAngle.angleBetween(actor, playState._player, true);
			}

			bullet.speed = this.recoilForce;
			bullet.damage = this.damage;
			bullet.changeSize(this.sizeOfBarrel);
			bullet.reset(actor.x + actor.width / 2, actor.y);

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
