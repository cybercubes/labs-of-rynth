package ;

import flixel.FlxState;
import actors.Player;
import actors.brain.Monster;
import actors.Coin;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;

class PlayState extends FlxState
{
	var _monsterS:FlxTypedGroup<Monster>;
	var _player:Player;
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpCoins:FlxTypedGroup<Coin>;

	override public function create():Void
	{
		super.create();
		
		_map = new FlxOgmoLoader(AssetPaths.room003__oel);

		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "walls");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(2, FlxObject.ANY);

		_grpCoins = new FlxTypedGroup<Coin>();

		_monsterS = new FlxTypedGroup<Monster>();

		_player = new Player();
		
		_map.loadEntities(placeEntities, "entities");
		
		add(_mWalls);
		add(_grpCoins);
		add(_player);
		add(_monsterS);

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (monster in _monsterS)
		{
			monster.findPlayer(_player);
		}
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		FlxG.collide(_monsterS, _mWalls);
 		_monsterS.forEachAlive(checkEnemyVision);
	}
	
	function checkEnemyVision(e:Monster):Void
	{
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
		}
		
	}

	function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "coin")
		{
			_grpCoins.add(new Coin(x + 4, y + 4));
		}
		else if (entityName == "monster")
		{
			 _monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}

	function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists)
		{
			C.kill();
		}
	}

}
