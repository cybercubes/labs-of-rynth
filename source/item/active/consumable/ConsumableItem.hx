package item.active.consumable;

import actors.Player;

class ConsumableItem extends ActiveItem {
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onUse(P:Player):Void {
		var lastItem = P.activeItems.last();
		P.activeItems.remove(lastItem);
	}
}
