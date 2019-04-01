package actors;

import flixel.ui.FlxBar;
import item.passive.Projectile;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.system.debug.console.ConsoleUtil;
import item.BaseItem;

class Player extends Actor {
	var hud:InGameHud;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);
		isPlayer = true;
		health = 100;

		healthBar = new FlxBar(2, 2, FlxBarFillDirection.LEFT_TO_RIGHT, 50, 6, this, "health");
		healthBar.scrollFactor.set(0,0);

		speed = 150;

		loadGraphic(AssetPaths.player__png, true, 16, 16);

		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);

		drag.x = drag.y = 2400; // drag is a value that determines how quickly the body will slowdown
		setSize(8, 14);
		offset.set(4, 2);

		bullets = new FlxTypedGroup(50);
		var bullet:Projectile;

		// Create 10 bullets for the player to recycle
		for (i in 0...bullets.maxSize) {
			// Instantiate a new sprite offscreen
			bullet = new Projectile();
			// Add it to the group of player bullets
			bullets.add(bullet);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		movement();
		useActiveItem();
		selectWeapon();

		if (FlxG.keys.justPressed.E) {
			for (item in playState._grpItems) {
				if (FlxG.overlap(this, item)) {
					ConsoleUtil.log("Overlaped with: " + item.name);
					if (item.isPickable()) {
						pickUpAnItem(item);
						break;
					}
				}
			}
		}
	}

	function movement():Void {
		goesUp = false;
		goesDown = false;
		goesLeft = false;
		goesRight = false;

		goesUp = FlxG.keys.anyPressed([UP, W]);
		goesDown = FlxG.keys.anyPressed([DOWN, S]);
		goesLeft = FlxG.keys.anyPressed([LEFT, A]);
		goesRight = FlxG.keys.anyPressed([RIGHT, D]);

		if (goesUp && goesDown)
			goesUp = goesDown = false;
		if (goesLeft && goesRight)
			goesLeft = goesRight = false;

		if (goesLeft || goesRight || goesUp || goesDown) {
			mA = 0;
			if (goesUp) {
				mA = -90;
				if (goesLeft)
					mA -= 45;
				else if (goesRight)
					mA += 45;
				facing = FlxObject.UP;
			} else if (goesDown) {
				mA = 90;
				if (goesLeft)
					mA += 45;
				else if (goesRight)
					mA -= 45;
				facing = FlxObject.DOWN;
			} else if (goesLeft) {
				mA = 180;
				facing = FlxObject.LEFT;
			} else if (goesRight) {
				mA = 0;
				facing = FlxObject.RIGHT;
			}
			velocity.set(speed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), mA);

			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
				switch (facing) {
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}
	}

	// using an active item
	function useActiveItem():Void {
		if (FlxG.keys.justPressed.SPACE) {
			if (activeItems.length > 0) {
				var lastItem = activeItems.last();
				lastItem.onUse(this);
			} else {
				ConsoleUtil.log("No active items to use!");
			}
		} else if (FlxG.mouse.pressed) {
			if (weapons.length > 0) {
				if (selectedWeapon.onUse(this)) {
					ConsoleUtil.log("Fired!");
				} else {
					ConsoleUtil.log("Not fired!");
				}
			} else {
				ConsoleUtil.log("No weapons to use!");
			}
		}

		// displaying items in a log
		if (FlxG.keys.justPressed.I) {
			var activeItemsLog:String = "Active Items: ";
			for (item in activeItems) {
				activeItemsLog += item.name + ";";
			}

			var passiveItemsLog:String = "Passive Items: ";
			for (item in passiveItems) {
				passiveItemsLog += item.name + ";";
			}

			var weaponsLog:String = "weapons: ";
			for (item in weapons) {
				weaponsLog += item.name + ";";
			}

			ConsoleUtil.log(activeItemsLog);
			ConsoleUtil.log(passiveItemsLog);
			ConsoleUtil.log(weaponsLog);

			ConsoleUtil.log("Health: " + this.health);
		}
	}

	function pickUpAnItem(I:BaseItem):Void {
		if (exists && alive) {
			I.alive = false;
			I.visible = false;
			I.setPosition(0, 0);
			I.owner = this;
			if (I.isActive) {
				if (I.isWeapon) {
					if (weapons.members.length == weapons.maxSize) {
						ConsoleUtil.log("DROP: " + selectedWeapon.name);

						selectedWeapon.alive = true;
						selectedWeapon.visible = true;
						selectedWeapon.setPosition(x, y);

						var indexOfSelectedWeapon = weapons.members.indexOf(selectedWeapon);
						weapons.members[indexOfSelectedWeapon] = I;
					} else {
						weapons.add(I);
					}
					selectedWeapon = I;
				} else {
					activeItems.add(I);
				}
			} else {
				passiveItems.add(I);
			}
		}
	}

	function selectWeapon():Void {
		if (FlxG.keys.justPressed.ONE) {
			selectedWeapon = weapons.members[0];
		} else if (FlxG.keys.justPressed.TWO) {
			if (weapons.length == 1) {
				return;
			}
			selectedWeapon = weapons.members[1];
		}
	}
}
