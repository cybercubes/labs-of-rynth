package item.active;

import actors.Player;
import flixel.FlxSprite;

class MeleeWeapon extends ActiveItem {
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
		return true;
	}
}
