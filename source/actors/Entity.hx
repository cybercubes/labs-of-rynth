package actors;

import item.passive.Projectile;
import flixel.FlxSprite;
import flixel.ui.FlxBar;

class Entity extends FlxSprite {
	public var healthBar:FlxBar;

	
	public function takeDamage(p:Projectile):Void {
		this.hurt(p.damage);

		if (health <= 0) {
			healthBar.kill();
		}
	}
      public function new(?X:Float=0, ?Y:Float=0, EType:Int)
    {
        super(X, Y);
        healthBar = new FlxBar(16, 64, FlxBarFillDirection.LEFT_TO_RIGHT, 32, 4, this, "health");
	    healthBar.trackParent(-7, -8);
    }
}
