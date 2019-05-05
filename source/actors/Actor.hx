package actors;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;
import item.BaseItem;
import item.passive.Projectile;
import buffs.Buff;

class Actor extends FlxSprite {
	public var speed:Float;
	public var activeItems:List<BaseItem>;
	public var passiveItems:List<BaseItem>;
	public var weapons:FlxTypedGroup<BaseItem>;
	public var buffs:List<Buff>;
	public var healthBar:FlxBar;
	public var goesUp:Bool;
	public var goesDown:Bool;
	public var goesLeft:Bool;
	public var goesRight:Bool;
	public var mA:Float;
	public var indexOfselectedWeapon:Int;
	public var isPlayer:Bool;

	// Buffable properties
	public static inline var SPEED = "speed";
	public static inline var HEALTH = "health";

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		// Определяет, как поворачивается персонаж в сторону когда смотрит в определённом направлении
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		// Создание полосы здоровья над игровым персонажем
		healthBar = new FlxBar(16, 64, FlxBarFillDirection.LEFT_TO_RIGHT, 32, 4, this, "health");
		healthBar.trackParent(-7, -8);

		activeItems = new List<BaseItem>();
		passiveItems = new List<BaseItem>();

		weapons = new FlxTypedGroup<BaseItem>(2);
		buffs = new List<Buff>();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

	}

	public static function takeDamage(p:Projectile, a:Actor):Void {
		if ((p.owner.isPlayer && !a.isPlayer) || (!p.owner.isPlayer && a.isPlayer)) {
			a.hurt(p.damage);
			if (!p.buffsToPass.isEmpty()) {
				for (buff in p.buffsToPass) {
					buff.apply(a);
				}
			}
			p.kill();

			if (a.health <= 0) {
				a.healthBar.kill();
			}
		}
	}
}
