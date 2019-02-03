package actors;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;


class Coin extends FlxSprite
{
    public function new(X:Float=0, Y:Float=0) 
    {
        super(X, Y);
        loadGraphic(AssetPaths.coin__png, false, 8, 8);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    override public function kill():Void
    {
        alive = false;
        FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33, { ease: FlxEase.circOut, onComplete: finishKill });
    }

    function finishKill(_):Void
    {
        exists = false;
    }


}