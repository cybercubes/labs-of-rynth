package item.active;

import actors.Player;

class ConsumableItem extends ActiveItem {
	var healthToRestore:Int;
	var times:Int;

	public function new(X:Float = 0, Y:Float = 0, Name:String, healthToRestore:Int, times:Int = 1) {
		super(X, Y);
		isWeapon = false;
		name = Name;
		loadGraphic("assets/images/active_items/" + name + ".png", false, 8, 8);
		this.healthToRestore = healthToRestore;
		this.times = times;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onUse(P:Player):Bool {
		var lastItem = P.activeItems.last();
		P.activeItems.remove(lastItem);

		if (times > 1) {
			var iteration = 0;
			var timer = new haxe.Timer(2000); // 2000ms delay
			timer.run = function() {
				P.health = P.health + healthToRestore;
				iteration += 1;
				if (iteration == times) {
					timer.stop();
				}
			}
		} else {
			P.health = P.health + healthToRestore;
		}
		return true;
	}
}
