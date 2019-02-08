package item.active.consumable;

import actors.Player;

class Food extends ConsumableItem {
	var healthToRestore:Int;

	public function new(X:Float = 0, Y:Float = 0, Name:String, healthToRestore:Int) {
		super(X, Y);
		name = Name;
		loadGraphic("assets/images/active_items/" + name + ".png", false, 8, 8);
		this.healthToRestore = healthToRestore;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onUse(P:Player):Void {
		super.onUse(P);
		var iteration = 0;
		var timer = new haxe.Timer(2000); // 2000ms delay
		timer.run = function() {
			P.health = P.health + healthToRestore;
			iteration += 1;
			if (iteration == 3) {
				timer.stop();
			} 
		}
	}
}
