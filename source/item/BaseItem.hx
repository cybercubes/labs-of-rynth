package item;

import actors.Player;
import flixel.FlxSprite;
import flixel.FlxG;

class BaseItem extends FlxSprite {
	public function new(X:Float = 0, Y:Float = 0) {
		super(X + 4, Y + 4);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	static public function makePickable(P:Player, I:BaseItem):Void {
		if (P.alive && P.exists && I.alive && I.exists) {
			if (FlxG.keys.pressed.E) {
				P.inventory.add(I);
				I.kill();
			}
		}
	}
}
