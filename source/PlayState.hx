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
import item.active.ConsumableItem;
import item.active.weapon.Weapon;
import item.active.weapon.TypeOfShooting;
import flixel.util.helpers.FlxBounds;
import flixel.math.FlxPoint;
import item.passive.Projectile;

class PlayState extends FlxState
{
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpItems:FlxTypedGroup<BaseItem>;
  	var _monsterS:FlxTypedGroup<Monster>;
	var _player:Player;

	public var _playerBullets:FlxTypedGroup<Projectile>;

	var _vsPlayerBullets:FlxGroup;

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

		_playerBullets = new FlxTypedGroup<Projectile>();
		_vsPlayerBullets = new FlxGroup();

		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpItems);
		add(_player);
		add(_monsterS);
		for (monster in _monsterS) {
			add(monster.healthBar);
		}

		add(_player.healthBar);

		// First we will instantiate the bullets you fire at your enemies.
		var numPlayerBullets:Int = 10;
		// Initializing the array is very important and easy to forget!
		_playerBullets = new FlxTypedGroup(numPlayerBullets);
		var bullet:Projectile;

		// Create 10 bullets for the player to recycle
		for (i in 0...numPlayerBullets) {
			// Instantiate a new sprite offscreen
			bullet = new Projectile(new FlxBounds<Int>(4, 4), 100);
			// Add it to the group of player bullets
			_playerBullets.add(bullet);
		}

		add(_playerBullets);
		_vsPlayerBullets.add(_monsterS);

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		for (monster in _monsterS)//updates state of the monsters
		{
			//monster.findPlayer(_player);
		}

		FlxG.collide(_player, _mWalls);
		FlxG.collide(_monsterS, _mWalls);
		FlxG.collide(_playerBullets, _mWalls, killBullet);
 		_monsterS.forEachAlive(checkEnemyVision);

		FlxG.overlap(_player, _grpItems, _player.pickUpAnItem);
		FlxG.overlap(_playerBullets, _vsPlayerBullets, hurt);

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
				case "pistol":
					_grpItems.add(new Weapon(x, y, name, 25, 0.5, TypeOfShooting.STRAIGHT));
			}
		}
		else if (entityName == "monster")
		{
			 _monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}

	function hurt(Object1:Projectile, Object2:Monster):Void {
		Object1.kill();
		Object2.takeDamage(Object1);
	}

	function killBullet(Object1:FlxObject, Object2:FlxObject):Void {
		Object1.kill();
	}
}
