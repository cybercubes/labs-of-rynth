package item.active;

import flixel.FlxObject;
import flixel.FlxG;
import flixel.FlxSprite;
import actors.Player;

class Weapon extends ActiveItem {
	public var damage:Int;
	public var speed:Float;

	var owner:FlxSprite;

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
		if (P.facing == FlxObject.RIGHT) {
			bullet.velocity.x = 140;
		} else if (P.facing == FlxObject.LEFT) {
			bullet.velocity.x = -140;
		} else if (P.facing == FlxObject.UP) {
			bullet.velocity.y = -140;
		} else {
			bullet.velocity.y = 140;
		}
		return true;
	}
}
