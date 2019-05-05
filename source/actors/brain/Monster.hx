package actors.brain;

import item.passive.Projectiles;
import flixel.tile.FlxTilemap;
import item.passive.Projectile;
import flixel.group.FlxGroup.FlxTypedGroup;
import item.active.weapon.TypeOfShooting;
import item.active.weapon.Weapon;
import flixel.math.FlxVelocity;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import actors.Player;
import utils.MathUtils;
import flixel.math.FlxAngle;

class Monster extends Actor {
	public var range:Float = 0;

	private var _idleTmr:Float;
	private var _moveDir:Float;

	public var onWayToPoint:Bool = false;
	public var attackBegin:Bool = false;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):FlxPoint;
	public var etype(default, null):Int;
	public var distance:Float; // distance between monster and player

	private var goGoPoint:FlxPoint = new FlxPoint(452, 224);

	// public static var sharedBullets:FlxTypedGroup<Projectile>;

	public function new(?X:Float = 0, ?Y:Float = 0, EType:Int) {
		super(X, Y);
		isPlayer = false;
		etype = EType;
		loadGraphic("assets/images/enemy-" + etype + ".png", true, 16, 16);
		animation.add("d", [0, 1, 0, 2], 6, false);
		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);

		speed = 50;

		health = 100;

		drag.x = drag.y = 50; // drag is a value that determines how quickly the body will slowdown
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;
		_idleTmr = 0;
		playerPos = FlxPoint.get();


		var weapon = new Weapon(x, y, "pistol", 50, 0.5, 1, TypeOfShooting.STRAIGHT, 1, Projectiles.SMALL);
    
		weapon.visible = false;
		weapon.alive = false;
		weapon.owner = this;
		weapons.add(weapon);
		indexOfselectedWeapon = 0;
	}

	override public function draw():Void {
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
			if (Math.abs(velocity.x) > Math.abs(velocity.y)) {
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			} else {
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}

			switch (facing) {
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");

				case FlxObject.UP:
					animation.play("u");

				case FlxObject.DOWN:
					animation.play("d");
			}
		}
		super.draw();
	}

	public function findPlayer(p:Player):Void // finds distance between monster and the player
	{
		var cat1:Float = p.x - this.x;
		var cat2:Float = p.y - this.y;

		distance = Math.sqrt((cat2 * cat2) + (cat1 * cat1));
	}

	public function chase():Void {
		if (seesPlayer) {
			FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
		}
	}

	public function findPathToPlayer(walls:FlxTilemap, p:Player):Void {
		if (!seesPlayer) {
			if (!onWayToPoint) {
				var faceAngle:Float = MathUtils.toDegrees(FlxAngle.angleBetween(this, p, true));
				var rowAngle:Float = faceAngle - 90;
				var monsterfirstPoint:FlxPoint = new FlxPoint(0, 0);
				var monsterchildPoint:FlxPoint = new FlxPoint(0, 0);
				var playerfirstPoint:FlxPoint = new FlxPoint(0, 0);
				var playerchildPoint:FlxPoint = new FlxPoint(0, 0);
				var interval:Float = 1;
				var numberOfPoints:Int = 20;
				var dX:Float = interval * Math.sin(MathUtils.toRads((90-rowAngle)));
				var dY:Float = interval * Math.sin(MathUtils.toRads(rowAngle));
				var xIncrementSign:Float = Math.abs(Math.cos(MathUtils.toRads(faceAngle))) / Math.cos(MathUtils.toRads(faceAngle));
				var yIncrementSign:Float = Math.abs(Math.sin(MathUtils.toRads(faceAngle))) / Math.sin(MathUtils.toRads(faceAngle));

				monsterfirstPoint.x = (numberOfPoints / 2 * dX) + (this.x * xIncrementSign);
				monsterfirstPoint.y = (numberOfPoints / 2 * dY) + (this.y * yIncrementSign);

				playerfirstPoint.x = (numberOfPoints / 2 * dX) + (p.x * xIncrementSign);
				playerfirstPoint.y = (numberOfPoints / 2 * dY) + (p.y * yIncrementSign);

			
				for (i in 1...numberOfPoints) {
					if (i == 1) {
						if (walls.ray(this.getMidpoint(), playerfirstPoint)) {
							if (walls.ray(playerfirstPoint, p.getMidpoint())) {
								//FlxVelocity.moveTowardsPoint(this, playerfirstPoint, Std.int(speed));
								goGoPoint.x = playerfirstPoint.x;
								goGoPoint.y = playerfirstPoint.y;
								
							}
						} else {
							if (walls.ray(this.getMidpoint(), monsterfirstPoint)) {
								if (walls.ray(monsterfirstPoint, playerfirstPoint)) {
									if (walls.ray(playerfirstPoint, p.getMidpoint())) {
										//FlxVelocity.moveTowardsPoint(this, monsterfirstPoint, Std.int(speed));
										//FlxVelocity.moveTowardsPoint(this, playerfirstPoint, Std.int(speed));
										goGoPoint.x = monsterfirstPoint.x;
										goGoPoint.y = monsterfirstPoint.y;
										
									}
								}
							}
						}
					} else {
						monsterchildPoint.x = monsterfirstPoint.x * (dX * xIncrementSign * i);
						monsterchildPoint.y = monsterfirstPoint.y * (dY * yIncrementSign * i);

						playerchildPoint.x = playerfirstPoint.x * (dX * xIncrementSign * i);
						playerchildPoint.y = playerfirstPoint.y * (dY * yIncrementSign * i);

						if (walls.ray(this.getMidpoint(), playerchildPoint)) {
							if (walls.ray(playerchildPoint, p.getMidpoint())) {
								//FlxVelocity.moveTowardsPoint(this, playerchildPoint, Std.int(speed));
								goGoPoint.x = playerchildPoint.x;
								goGoPoint.y = playerchildPoint.y;
								
							}
						} else {
							if (walls.ray(this.getMidpoint(), monsterchildPoint)) {
								if (walls.ray(monsterchildPoint, playerchildPoint)) {
									if (walls.ray(playerchildPoint, p.getMidpoint())) {
										//FlxVelocity.moveTowardsPoint(this, monsterchildPoint, Std.int(speed));
										//FlxVelocity.moveTowardsPoint(this, playerchildPoint, Std.int(speed));
										goGoPoint.x = monsterchildPoint.x;
										goGoPoint.y = monsterchildPoint.y;
										
									}
								}
							}
						}
					}
					FlxVelocity.moveTowardsPoint(this, goGoPoint, Std.int(speed));
					//onWayToPoint = true;
				}
			}else{ 
				if (this.x == goGoPoint.x && this.y == goGoPoint.y) {
					onWayToPoint = false;
				}
				
			}
		}
	}

	override public function update(elapsed:Float):Void {
		attack();
		chase();
		super.update(elapsed);
	}

	function attack():Void {
		if (attackBegin) {
			weapons.members[indexOfselectedWeapon].onUse(this);
		}
	}
}
