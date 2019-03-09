package;

import flixel.util.FlxColor;
import flixel.addons.weapon.FlxWeapon;
import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;
import actors.Player;
import item.BaseItem;
import item.passive.PassiveItem;
import item.active.ConsumableItem;
import flixel.addons.weapon.FlxBullet;
import flixel.util.helpers.FlxBounds;
import flixel.math.FlxPoint;

class PlayState extends FlxState {
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpItems:FlxTypedGroup<BaseItem>;
	var _player:Player;

	override public function create():Void {
		super.create();

		_map = new FlxOgmoLoader(AssetPaths.room002__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		_grpItems = new FlxTypedGroup<BaseItem>();
		_player = new Player();

		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpItems);
		add(_player);
		add(_player.healthBar);

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpItems, _player.pickUpAnItem);
	}

	function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		} else if (entityName == "item") {
			var name:String = entityData.get("name");
			switch (name) {
				case "apple":
					_grpItems.add(new ConsumableItem(x, y, name, 5, 3));
				case "elixir":
					_grpItems.add(new ConsumableItem(x, y, name, 20));
				case "diamond":
					_grpItems.add(new PassiveItem(x, y, name));
				case "pistol":
					_grpItems.add(new FlxWeapon(name, // the following function is the factory function.
						// FlxWeapon will call this function to get an instance of
						// bullet whenever it has to create one
					function(weapon) {
						// so you create the bullet, do something to it, then return it
						var b = new FlxBullet();
						b.makeGraphic(4, 4, FlxColor.RED);
						return b;
					}, FlxWeaponFireFrom.PARENT(_player, new FlxBounds<FlxPoint>(FlxPoint.get(0, 0))), FlxWeaponSpeedMode.SPEED(new FlxBounds<Float>(500)), x, y));
			}
		}
	}
}
