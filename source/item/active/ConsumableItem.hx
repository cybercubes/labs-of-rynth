package item.active;

class ConsumableItem extends ActiveItem {
	public function new(X:Float = 0, Y:Float = 0, Name:String) {
		super(X, Y);
		loadGraphic("assets/images/active_items/" + Name + ".png", false, 8, 8);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
