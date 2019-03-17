package;

import actors.Actor;
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
import item.passive.Projectile;

class PlayState extends FlxState {
	var _map:FlxOgmoLoader;
	var _mWalls:FlxTilemap;
	var _grpItems:FlxTypedGroup<BaseItem>;
	var _monsterS:FlxTypedGroup<Monster>;

	public var _player:Player;
	public var _playerBullets:FlxTypedGroup<Projectile>;
	public var _enemyBullets:FlxTypedGroup<Projectile>;

	var _vsPlayerBullets:FlxGroup;
	var _vsEnemyBullets:FlxGroup;
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
		_vsPlayerBullets = new FlxGroup();
		_vsEnemyBullets = new FlxGroup();

		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpItems);
		add(_player);
		add(_monsterS);
		for (monster in _monsterS) {
			add(monster.healthBar);
			add(monster.weapons);
		}

		add(_player.healthBar);

		//
		// First we will instantiate the bullets you fire at your enemies.
		var numPlayerBullets:Int = 50;
		// Initializing the array is very important and easy to forget!
		_playerBullets = new FlxTypedGroup(numPlayerBullets);
		var bullet:Projectile;

		// Create 10 bullets for the player to recycle
		for (i in 0...numPlayerBullets) {
			// Instantiate a new sprite offscreen
			bullet = new Projectile();
			// Add it to the group of player bullets
			_playerBullets.add(bullet);
		}

		add(_playerBullets);
		_vsPlayerBullets.add(_monsterS);
		//

		//
		var numEnemyBullets:Int = 50;
		_enemyBullets = new FlxTypedGroup(numEnemyBullets);
		var bullet:Projectile;

		for (i in 0...numEnemyBullets) {
			bullet = new Projectile();
			_enemyBullets.add(bullet);
		}

		add(_enemyBullets);
		_vsEnemyBullets.add(_player);
		//

		FlxG.camera.follow(_player, TOPDOWN, 1);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		for (monster in _monsterS) // updates state of the monsters
		{
			// monster.findPlayer(_player);
		}

		FlxG.collide(_player, _mWalls);
		FlxG.collide(_monsterS, _mWalls);
		FlxG.collide(_playerBullets, _mWalls, killBullet);
		FlxG.collide(_enemyBullets, _mWalls, killBullet);

		_monsterS.forEachAlive(checkEnemyVision);

		FlxG.overlap(_player, _grpItems, _player.pickUpAnItem);
		FlxG.overlap(_playerBullets, _vsPlayerBullets, hurt);
		FlxG.overlap(_enemyBullets, _vsEnemyBullets, hurt);

		if (FlxG.keys.pressed.ESCAPE)
			openSubState(pauseSubState);
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
					_grpItems.add(new Weapon(x, y, name, 10, 0.1, 100, TypeOfShooting.STRAIGHT, 1, new FlxBounds<Int>(4, 4)));
				case "shotgun":
					_grpItems.add(new Weapon(x, y, name, 25, 1, 100, TypeOfShooting.SHOTGUN, 3, new FlxBounds<Int>(6, 6)));
			}
		} else if (entityName == "monster") {
			_monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}

	function hurt(Object1:Projectile, Object2:Actor):Void {
		Object1.kill();
		Object2.takeDamage(Object1);
	}

	function killBullet(Object1:FlxObject, Object2:FlxObject):Void {
		Object1.kill();
	}
}
