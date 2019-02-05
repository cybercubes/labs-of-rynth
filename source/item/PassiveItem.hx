package item;

class PassiveItem extends BaseItem {
	public function new(X:Float = 0, Y:Float = 0, Name:String) {
		super(X, Y);
		isActive = false;
		loadGraphic("assets/images/passive_items/" + Name + ".png", false, 8, 8);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
