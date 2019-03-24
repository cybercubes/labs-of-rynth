package;

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
import item.active.ConsumableItem;
import item.active.weapon.Weapon;
import item.active.weapon.TypeOfShooting;
import flixel.util.helpers.FlxBounds;

class PlayState extends FlxState {
	var _map:FlxOgmoLoader;

	public var _mWalls:FlxTilemap;
	public var _grpItems:FlxTypedGroup<BaseItem>;
	public var _monsterS:FlxTypedGroup<Monster>;
	public var _player:Player;

	//SubStates
	var pauseSubState:PauseState;
	var gameOverState:GameOverState;
	var pauseSubStateColor:FlxColor;

	override public function create():Void {
		super.create();

		destroySubStates = false;
		pauseSubStateColor = 0x99808080;
		pauseSubState = new PauseState(pauseSubStateColor);
		gameOverState = new GameOverState();

		_map = new FlxOgmoLoader(AssetPaths.room002__oel);
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
		add(_player.healthBar);
		add(_player.bullets);

		add(_monsterS);
		for (monster in _monsterS) {
			add(monster.healthBar);
			add(monster.weapons);
			add(monster.bullets);
		}

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		for (monster in _monsterS) // updates state of the monsters
		{
			// monster.findPlayer(_player);
		}

		_monsterS.forEachAlive(checkEnemyVision);

		if (FlxG.keys.pressed.ESCAPE)
			openSubState(pauseSubState);

		if (_player.alive == false)
			openSubState(gameOverState);
	}

	function checkEnemyVision(e:Monster):Void {
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint())) {
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
		}
	}

	override public function destroy():Void {
		super.destroy();

		pauseSubState.destroy();
		pauseSubState = null;
		gameOverState.destroy();
		gameOverState = null;
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
				case "pistol":
					_grpItems.add(new Weapon(x, y, name, 2, 0.5, 70, TypeOfShooting.STRAIGHT, 1, new FlxBounds<Float>(4, 4)));
				case "shotgun":
					_grpItems.add(new Weapon(x, y, name, 25, 1, 70, TypeOfShooting.SHOTGUN, 4, new FlxBounds<Float>(4, 4)));
				case "wand":
					_grpItems.add(new Weapon(x, y, name, 10, 0.5, 70, TypeOfShooting.STRAIGHT, 15, new FlxBounds<Float>(6, 6)));
			}
		} else if (entityName == "monster") {
			_monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
          
}