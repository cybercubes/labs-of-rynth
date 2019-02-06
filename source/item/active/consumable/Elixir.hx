package item.active.consumable;

class Elixir extends ConsumableItem {
	var healthToRestore:Int;

	public function new(X:Float = 0, Y:Float = 0, Name:String, healthToRestore:Int) {
		super(X, Y);
		name = Name;
		loadGraphic("assets/images/active_items/" + Name + ".png", false, 8, 8);
		this.healthToRestore = healthToRestore;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
