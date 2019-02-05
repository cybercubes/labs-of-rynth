package item.active;

class ActiveItem extends BaseItem {

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y);
		isActive = true;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}
	
}
