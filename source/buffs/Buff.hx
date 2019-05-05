package buffs;

import actors.Actor;
import flixel.util.FlxTimer;

class Buff {
	var propertyToChange:String;
	var value:Float;
	var time:Float = 0;
	var timer:FlxTimer;

	public function new(propertyToChange:String, value:Float, time:Float = 0) {
		this.propertyToChange = propertyToChange;
		this.value = value;
		this.time = time;
	}

	public function apply(actor:Actor):Void {
		timer = new FlxTimer();

		if (time > 0) {
			timer.start(time);
		}
		switch (propertyToChange) {
			case "speed":
				for (buff in actor.buffs) {
					if (buff == this) {
						buff.timer.reset(time);
						return;
					}
				}
				actor.speed += value;
				if (timer.active) {
					timer.onComplete = function(Timer:FlxTimer) {
						actor.speed -= value;
					};
				}
			case "health":
				actor.health += value;
				if (timer.active) {
					timer.onComplete = function(Timer:FlxTimer) {
						actor.health -= value;
					};
				}
		}
	}
}
