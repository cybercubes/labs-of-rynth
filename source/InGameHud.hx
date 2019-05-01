package ;
import actors.Actor;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class InGameHud extends FlxTypedGroup<FlxSprite>
{
    var trt:FlxSprite;
    var trt2:FlxSprite;

    public function new()
    {
        super();

        trt = new FlxSprite().makeGraphic(8,8, FlxColor.WHITE, false);
        trt.x = 2;
        trt.y = 10;
        trt.scrollFactor.set(0,0);
        add(trt);


        trt2 = new FlxSprite().makeGraphic(6,6, FlxColor.RED, false);
        trt2.x = 2;
        trt2.y = 20;
        trt2.scrollFactor.set(0,0);
        add(trt2);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        updateHUD();
    }

    public function updateHUD():Void
    {

    }
}

/*package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using flixel.util.FlxSpriteUtil;

class InGameHud extends FlxTypedGroup<FlxSprite>
{
    var _sprBack:FlxSprite;
    var _txtHealth:FlxText;
    var _txtMoney:FlxText;
    var _sprHealth:FlxSprite;
    var _sprMoney:FlxSprite;

    public function new()
    {
        super();
        _sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4, AssetPaths.shotgun__png);
        add(_sprHealth);
        add(_sprMoney);
        add(_txtHealth);
        add(_txtMoney);
        forEach(function(spr:FlxSprite)
        {
            spr.scrollFactor.set(0, 0);
        });
    }

    public function updateHUD(Health:Int = 0, Money:Int = 0):Void
    {
        _txtHealth.text = Std.string(Health) + " / 3";
        _txtMoney.text = Std.string(Money);
        _txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
    }
}*/

