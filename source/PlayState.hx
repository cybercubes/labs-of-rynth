package ;

import flixel.util.FlxColor;
import flixel.FlxState;
import actors.brain.Monster;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;
import actors.Player;
import item.BaseItem;
import item.passive.PassiveItem;
import item.active.ConsumableItem;
import flixel.util.helpers.FlxBounds;
import flixel.math.FlxPoint;

class PlayState extends FlxState
{
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpItems:FlxTypedGroup<BaseItem>;
  	var _monsterS:FlxTypedGroup<Monster>;
	var _player:Player;

	// Pause Menu States
	var pauseSubState:PauseState;
	var subStateColor:FlxColor;

	override public function create():Void {
		super.create();

		subStateColor = 0x99808080;

		pauseSubState = new PauseState(subStateColor);

		_map = new FlxOgmoLoader(AssetPaths.room003__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);
    
		_monsterS = new FlxTypedGroup<Monster>();
		_grpItems = new FlxTypedGroup<BaseItem>();
		_player = new Player();

		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpItems);
		add(_player);
		add(_monsterS);
		add(_player.healthBar);

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		for (monster in _monsterS)
		{
			monster.findPlayer(_player);
		}
		FlxG.collide(_player, _mWalls);
		FlxG.collide(_monsterS, _mWalls);
 		_monsterS.forEachAlive(checkEnemyVision);

		FlxG.overlap(_player, _grpItems, _player.pickUpAnItem);

		if (FlxG.keys.pressed.ESCAPE)   openSubState(pauseSubState);
	}
  
	function checkEnemyVision(e:Monster):Void
	{
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
		}
    
 	}

	override public function destroy():Void
	{
		super.destroy();

		pauseSubState.destroy();
		pauseSubState = null;
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
			}
		}
		else if (entityName == "monster")
		{
			 _monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
}
