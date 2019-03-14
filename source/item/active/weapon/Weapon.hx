package item.active.weapon;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import actors.Player;
import item.passive.Projectile;

class Weapon extends ActiveItem {
	public var damage:Int;
	public var speed:Float;
	public var recoilForce:Float;
	public var shotCooldown:Float;
	public var typeOfShooting:String;
	public var bulletsToShoot:FlxTypedGroup<Projectile>;

	public function new(X:Float = 0, Y:Float = 0, Name:String, Damage:Int, Speed:Float, RecoilForce:Float, typeOfShooting:String) {
		super(X, Y);
		isWeapon = true;
		name = Name;
		loadGraphic("assets/images/active_items/weapons/" + name + ".png", false, 8, 8);
		this.damage = Damage;
		this.speed = Speed;
		this.recoilForce = RecoilForce;
		this.typeOfShooting = typeOfShooting;
		switch (typeOfShooting) {
			case TypeOfShooting.STRAIGHT:
				bulletsToShoot = new FlxTypedGroup(1);
			case TypeOfShooting.SHOTGUN:
				bulletsToShoot = new FlxTypedGroup(3);
		}
	}

	override public function update(elapsed:Float):Void {
		if (shotCooldown < speed) {
			shotCooldown += elapsed;
		}
		super.update(elapsed);
	}

	override public function onUse(P:Player):Bool {
		if (shotCooldown < speed) {
			return false;
		}

		var playState:PlayState = cast FlxG.state;

		for (i in 0...bulletsToShoot.maxSize) {
			var finalAngle:Float = P.mA;
			var bullet:Projectile = playState._playerBullets.recycle();
			bullet.speed = this.recoilForce;
			bullet.damage = this.damage;
			bullet.reset(P.x + P.width / 2, P.y);

			if (typeOfShooting == TypeOfShooting.SHOTGUN) {
				finalAngle = -15 + finalAngle + (15 * i);
			}

			bullet.move(finalAngle, typeOfShooting);
			bulletsToShoot.add(bullet);
		}

		shotCooldown = 0;

		return true;
	}
}
