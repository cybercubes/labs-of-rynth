package item.active;

import actors.Actor;

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

	override public function onUse(actor:Actor):Bool {
		var lastItem = actor.activeItems.last();
		actor.activeItems.remove(lastItem);

		if (times > 1) {
			var iteration = 0;
			var timer = new haxe.Timer(2000); // 2000ms delay
			timer.run = function() {
				actor.health = actor.health + healthToRestore;
				iteration += 1;
				if (iteration == times) {
					timer.stop();
				}
			}
		} else {
			actor.health = actor.health + healthToRestore;
		}
		return true;
	}
}
