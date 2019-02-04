package;

import flixel.FlxState;
import actors.Player;
import item.BaseItem;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;

class PlayState extends FlxState {
	var _player:Player;
	var _grpItems:FlxTypedGroup<BaseItem>;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;

	override public function create():Void {
		super.create();

		_map = new FlxOgmoLoader(AssetPaths.room002__oel);

		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);

		_player = new Player();
		_grpItems = new FlxTypedGroup<Item>();

		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpItems);
		add(_player);

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(_player, _mWalls);
		// FlxG.overlap(_player, _grpCoins, playerTouchCoin);
	}

	function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		} else if (entityName == "item") {
			_grpItems.add(new Item(x, y));
		}
	}
}
