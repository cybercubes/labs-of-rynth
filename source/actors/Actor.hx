package actors;

import item.passive.Projectile;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxBar;
import item.BaseItem;

class Actor extends FlxSprite {
	public var speed:Float;
	public var activeItems:List<BaseItem>;
	public var passiveItems:List<BaseItem>;
	public var weapons:FlxTypedGroup<BaseItem>;
	public var healthBar:FlxBar;
	public var goesUp:Bool;
	public var goesDown:Bool;
	public var goesLeft:Bool;
	public var goesRight:Bool;
	public var mA:Float;
	public var selectedWeapon:BaseItem;
    public var isPlayer:Bool;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		healthBar = new FlxBar(16, 64, FlxBarFillDirection.LEFT_TO_RIGHT, 32, 4, this, "health");
		healthBar.trackParent(-7, -8);

		activeItems = new List<BaseItem>();
		passiveItems = new List<BaseItem>();

		weapons = new FlxTypedGroup<BaseItem>();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	public function takeDamage(p:Projectile):Void {
		this.hurt(p.damage);

		if (health <= 0) {
			healthBar.kill();
		}
	}


}
