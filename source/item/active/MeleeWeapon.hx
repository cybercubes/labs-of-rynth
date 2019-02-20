package item.active;

import actors.Player;

class MeleeWeapon extends ActiveItem {

    var damage:Int;
    var speed:Float;

	public function new(X:Float = 0, Y:Float = 0, Name:String) {
		super(X, Y);

		name = Name;
		loadGraphic("assets/images/active_items/weapons/" + name + ".png", false, 8, 8);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
	}

	override public function onUse(P:Player):Void {
        
	}
}
