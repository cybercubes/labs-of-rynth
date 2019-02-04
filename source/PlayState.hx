package;

import flixel.FlxState;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;
import actors.Player;
import item.BaseItem;
import item.ActiveItem;

class PlayState extends FlxState {
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpActiveItems:FlxTypedGroup<ActiveItem>;
	var _player:Player;

	override public function create():Void {
		super.create();

		_map = new FlxOgmoLoader(AssetPaths.room002__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
		_grpActiveItems = new FlxTypedGroup<ActiveItem>();
		_player = new Player();

		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpActiveItems);
		add(_player);

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpActiveItems, BaseItem.makePickable);

	}

	function placeEntities(entityName:String, entityData:Xml):Void {
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player") {
			_player.x = x;
			_player.y = y;
		} else if (entityName == "item") {
			_grpActiveItems.add(new ActiveItem(x, y));
		}
	}
}
