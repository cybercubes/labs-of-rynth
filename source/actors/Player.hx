package actors;

import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.system.debug.console.ConsoleUtil;
import flixel.ui.FlxBar;
import item.BaseItem;


class Player extends FlxSprite {
	public var speed:Float = 100;
	public var activeItems:List<BaseItem>;
	public var passiveItems:List<BaseItem>;
	public var weapons:List<BaseItem>;
	public var healthBar:FlxBar;

	public function new(?X:Float = 0, ?Y:Float = 0) {
		super(X, Y);

		health = 20;
		healthBar = new FlxBar(16, 64, FlxBarFillDirection.LEFT_TO_RIGHT, 32, 4, this, "health");
		healthBar.trackParent(-7, -8);

		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);

		drag.x = drag.y = 2400; // drag is a value that determines how quickly the body will slowdown
		setSize(8, 14);
		offset.set(4, 2);

		activeItems = new List<BaseItem>();
		passiveItems = new List<BaseItem>();
		weapons = new List<BaseItem>();
	}

	override public function update(elapsed:Float):Void {
		movement();
		useActiveItem();
		super.update(elapsed);
	}

	function movement():Void {
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		_up = FlxG.keys.anyPressed([UP, W]);
		_down = FlxG.keys.anyPressed([DOWN, S]);
		_left = FlxG.keys.anyPressed([LEFT, A]);
		_right = FlxG.keys.anyPressed([RIGHT, D]);

		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		if (_left || _right || _up || _down) {
			var mA:Float = 0;
			if (_up) {
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;
				facing = FlxObject.UP;
			} else if (_down) {
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;
				facing = FlxObject.DOWN;
			} else if (_left) {
				mA = 180;
				facing = FlxObject.LEFT;
			} else if (_right) {
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

	function useActiveItem():Void {
		// using an active item
		if (FlxG.keys.justPressed.SPACE) {
			if (activeItems.length > 0) {
				var lastItem = activeItems.last();
				lastItem.onUse(this);
			} else {
				ConsoleUtil.log("No active items to use!");
			}
		} else if (FlxG.keys.justPressed.Z) {
			if (weapons.length > 0) {
				var weapon = weapons.last();
				var res = weapon.onUse(this);
				if (res) {
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

	public function pickUpAnItem(P:Player, I:BaseItem):Void {
		if (P.alive && P.exists && I.alive && I.exists) {
			if (FlxG.keys.pressed.E) {
				if (I.isActive) {
					if (I.isWeapon) {
						P.weapons.add(I);
					} else {
						P.activeItems.add(I);
					}
				} else {
					P.passiveItems.add(I);
				}
				I.kill();
			}
		}
	}
}
