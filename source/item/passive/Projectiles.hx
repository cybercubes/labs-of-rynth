package item.passive;

import flixel.group.FlxGroup;

class Projectiles {
	public static var BIG:FlxTypedGroup<Projectile>;
	public static var MEDIUM:FlxTypedGroup<Projectile>;
	public static var SMALL:FlxTypedGroup<Projectile>;
	public static var ALL:FlxTypedGroup<FlxTypedGroup<Projectile>>;

	public static function fill() {

		SMALL = new FlxTypedGroup(50);
		for (i in 0...SMALL.maxSize) {
			var projectile:Projectile = new Projectile(4, 4);
			SMALL.add(projectile);
		}

		MEDIUM = new FlxTypedGroup(50);
		for (i in 0...MEDIUM.maxSize) {
			var projectile:Projectile = new Projectile(6, 6);
			MEDIUM.add(projectile);
		}

		BIG = new FlxTypedGroup(50);
		for (i in 0...BIG.maxSize) {
			var projectile:Projectile = new Projectile(8, 8);
			BIG.add(projectile);
		}

		ALL = new FlxTypedGroup(3);
		ALL.add(BIG);
		ALL.add(MEDIUM);
		ALL.add(SMALL);

	}
}
