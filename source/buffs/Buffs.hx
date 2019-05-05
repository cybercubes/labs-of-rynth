package buffs;

import actors.Actor;

class Buffs {
	public static var ACCELERATION = new Buff(Actor.SPEED, 75, 1);
	public static var SLOWDOWN = new Buff(Actor.SPEED, -50, 2);
	public static var HEALING = new Buff(Actor.HEALTH, 25);
}
