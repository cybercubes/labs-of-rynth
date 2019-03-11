package item.active;

import actors.Player;
import flixel.util.FlxColor;
import item.passive.PassiveItem;

class Projectile extends PassiveItem {
	public var flySpeed:Int;
	public function new(p:Player) {
		super(p.x, p.y);
		// loadGraphic("assets/images/passive_items/projectile.png", false, 8, 8);
        makeGraphic(4, 4, FlxColor.RED);
		flySpeed = 100;
        exists = false;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
