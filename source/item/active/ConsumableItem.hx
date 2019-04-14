package item.active;

import actors.Actor;
import buffs.Buffs;

class ConsumableItem extends ActiveItem {
	public function new(X:Float = 0, Y:Float = 0, Name:String) {
		super(X, Y);
		isWeapon = false;
		name = Name;
		loadGraphic("assets/images/active_items/" + name + ".png", false, 8, 8);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onUse(actor:Actor):Bool {
		var lastItem = actor.activeItems.last();
		actor.activeItems.remove(lastItem);

		switch (name) {
			case "elixirOfSpeed":
				Buffs.SPEED.apply(actor);
			case "elixirOfHealth":
				Buffs.HEALTH.apply(actor);
		}

		return true;
	}
}
