package;

import item.passive.Projectiles;
import actors.Actor;
import item.passive.Projectile;
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
import enums.Trajectories;

class PlayState extends FlxState {
	public var _map:FlxOgmoLoader;
	public var _mWalls:FlxTilemap;
	public var _grpItems:FlxTypedGroup<BaseItem>;
	public var _monsterS:FlxTypedGroup<Monster>;
	public var _player:Player;
	public var _actors:FlxTypedGroup<Actor>;

	// SubStates
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
		_actors = new FlxTypedGroup<Actor>();
		Projectiles.fill();
		_map.loadEntities(placeEntities, "entities");

		add(_mWalls);
		add(_grpItems);

		for (monster in _monsterS) {
			_actors.add(monster);
		}

		_actors.add(_player);
		add(_actors);
		for (actor in _actors) {
			add(actor.healthBar);
			if (!actor.isPlayer) {
				add(actor.weapons);
			}
		}

		add(Projectiles.ALL);

		FlxG.camera.follow(_player, TOPDOWN, 1);

		FlxG.camera.fade(FlxColor.BLACK, .33, true);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		FlxG.collide(_actors, _mWalls);
		FlxG.collide(Projectiles.ALL, _mWalls, Projectile.collide);
		FlxG.overlap(Projectiles.ALL, _actors, Actor.takeDamage);
		

		_monsterS.forEachAlive(checkEnemyVision);

		if (FlxG.keys.pressed.ESCAPE)
			openSubState(pauseSubState);

		if (_player.alive == false)
			openSubState(gameOverState);
	}

	function checkEnemyVision(e:Monster):Void {
		e.playerPos.copyFrom(_player.getMidpoint());
		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint())) {
			e.seesPlayer = true;
			e.attackBegin = true;
		} else {
			e.seesPlayer = false;
			e.attackBegin = false;
			e.findPathToPlayer(_mWalls, _player);
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
				case "elixirOfHealth":
					_grpItems.add(new ConsumableItem(x, y, name));
				case "elixirOfSpeed":
					_grpItems.add(new ConsumableItem(x, y, name));
				case "pistol":
					_grpItems.add(new Weapon(x, y, name, 2, 0.2, 0.5, TypeOfShooting.STRAIGHT, Trajectories.STRAIGHT,  1, Projectiles.SMALL));
				case "shotgun":
					_grpItems.add(new Weapon(x, y, name, 25, 1, 0.75, TypeOfShooting.STRAIGHT, Trajectories.BURST,  3, Projectiles.MEDIUM, 30));
				case "wand":
					_grpItems.add(new Weapon(x, y, name, 10, 0.5, 1, TypeOfShooting.STRAIGHT, Trajectories.TURN, 15, Projectiles.BIG));
			}
		} else if (entityName == "monster") {
			_monsterS.add(new Monster(x + 4, y, Std.parseInt(entityData.get("etype"))));
		}
	}
}
