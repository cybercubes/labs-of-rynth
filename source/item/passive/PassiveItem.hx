package item.passive;

class PassiveItem extends BaseItem {
	public function new(X:Float = 0, Y:Float = 0, Name:String) {
		super(X, Y);
		name = Name;
		isActive = false;
		loadGraphic("assets/images/passive_items/" + name + ".png", false, 8, 8);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
}
