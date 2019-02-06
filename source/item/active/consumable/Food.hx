package item.active.consumable;

class Food extends ConsumableItem {
	var healthToRestorePerSec:Int;

	public function new(X:Float = 0, Y:Float = 0, Name:String, healthToRestorePerSec:Int) {
		super(X, Y);
		name = Name;
		loadGraphic("assets/images/active_items/" + Name + ".png", false, 8, 8);
		this.healthToRestorePerSec = healthToRestorePerSec;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
 