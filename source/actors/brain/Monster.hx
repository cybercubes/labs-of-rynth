package actors.brain;

import item.passive.Projectile;
import flixel.math.FlxVelocity;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import actors.brain.FSM;
import actors.Player;

  
 class Monster extends FlxSprite
 {
    public var range:Float = 0;
    private var _brain:FSM;
    private var _idleTmr:Float;
    private var _moveDir:Float;
   
    public var seesPlayer:Bool = false;
    public var playerPos(default, null):FlxPoint;
    public var speed:Float = 50;
    
    public var Damage:Float;
    public var etype(default, null):Int;
   	public var healthBar:FlxBar;

	private var distance:Float;//distance between monster and player
    
    public function new(?X:Float=0, ?Y:Float=0, EType:Int)
    {
        super(X, Y);
        etype = EType;
        loadGraphic("assets/images/enemy-" + etype + ".png", true, 16, 16);
        setFacingFlip(FlxObject.LEFT, false, false);
        setFacingFlip(FlxObject.RIGHT, true, false);
        animation.add("d", [0, 1, 0, 2], 6, false);
        animation.add("lr", [3, 4, 3, 5], 6, false);
        animation.add("u", [6, 7, 6, 8], 6, false);
      
        health = 100;
        healthBar = new FlxBar(16, 64, FlxBarFillDirection.LEFT_TO_RIGHT, 32, 4, this, "health");
        healthBar.trackParent(-7, -8);
      
        drag.x = drag.y = 10; //drag is a value that determines how quickly the body will slowdown
        width = 8;
        height = 14;
        offset.x = 4;
        offset.y = 2;
        _brain = new FSM(idle);
        _idleTmr = 0;
        playerPos = FlxPoint.get();
        health = 100;

    }

    override public function draw():Void
    {
        if ((velocity.x != 0 || velocity.y != 0 ) && touching == FlxObject.NONE)
        {
            if (Math.abs(velocity.x) > Math.abs(velocity.y))
            {
                if (velocity.x < 0)
                    facing = FlxObject.LEFT;
                else
                    facing = FlxObject.RIGHT;
            }
            else
            {
                if (velocity.y < 0)
                    facing = FlxObject.UP;
                else
                    facing = FlxObject.DOWN;
            }

            switch (facing)
            {
                case FlxObject.LEFT, FlxObject.RIGHT:
                    animation.play("lr");

                case FlxObject.UP:
                    animation.play("u");

                case FlxObject.DOWN:
                    animation.play("d");
            }
        }
        super.draw();
    }

    public function findPlayer(p:Player):Void //finds distance between monster and the player
    {   
    	var cat1:Float = p.x - this.x;
    	var cat2:Float = p.y - this.y;

    	distance = Math.sqrt((cat2 *cat2) + (cat1 * cat1));
    }

    public function takeDamage(p:Projectile):Void
    {
        this.hurt(p.damage);

        if (health <= 0)
        {
            healthBar.kill();
        }

    }
    
    public function idle():Void
    {
        if (seesPlayer)
        {
            _brain.activeState = chase;

        }
        else if (_idleTmr <= 0)
        {
            if (FlxG.random.bool(1))
            {
                _moveDir = -1;
                velocity.x = velocity.y = 0;
            }
            else
            {
                _moveDir = FlxG.random.int(0, 8) * 45;

                velocity.set(speed * 0.3, 0);
                velocity.rotate(FlxPoint.weak(), _moveDir);
                
            }
            _idleTmr = FlxG.random.int(1, 4);            
        }
        else
            _idleTmr -= FlxG.elapsed;

    }

    public function chase():Void
    {
        if (!seesPlayer)
        {
            _brain.activeState = idle;
        }
        else
        {
            FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
        }
    }
        
    override public function update(elapsed:Float):Void
    {   
        super.update(elapsed);
        _brain.update();
    }
}
