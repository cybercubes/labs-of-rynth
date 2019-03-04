package ;

import flixel.FlxState;
import actors.Player;
import actors.brain.Monster;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.group.FlxGroup;
import actors.Player;
import item.BaseItem;
import item.passive.PassiveItem;
import item.active.consumable.Food;
import item.active.consumable.Elixir;

class PlayState extends FlxState
{
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpItems:FlxTypedGroup<BaseItem>;
  	var _monsterS:FlxTypedGroup<Monster>;
	var _player:Player;


	override public function create():Void {
		super.create();

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

		FlxG.collide(_player, _mWalls);
		FlxG.collide(_monsterS, _mWalls);
 		_monsterS.forEachAlive(checkEnemyVision);

		FlxG.overlap(_player, _grpItems, _player.pickUpAnItem);

		if (FlxG.keys.pressed.ESCAPE) FlxG.switchState(new PauseState());
	}

	function checkEnemyVision(e:Monster):Void
	{
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()))
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
			//e.rememberPlayerPos = true;	
		}
		else if (e.rememberPlayerPos = true)
		{	
			e.seesPlayer = false;
		}
			else
		{
			e.seesPlayer = true;
		}
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
					_grpItems.add(new Food(x, y, name, 5));
				case "diamond":
					_grpItems.add(new PassiveItem(x, y, name));
				case "elixir":
					_grpItems.add(new Elixir(x, y, name, 20));
			}
		}
		else if (entityName == "monster")
		{
			 _monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
}
