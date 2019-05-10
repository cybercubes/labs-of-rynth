package ;
import actors.Player;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class InGameHud extends FlxTypedGroup<FlxSprite>
{
   public var trt:FlxSprite;
    public var trt2:FlxSprite;

    var weapon:Player;

    public function new()
    {
        super();

        trt = new FlxSprite().makeGraphic(18,10, FlxColor.WHITE, false);
        trt.x = 2;
        trt.y = 10;
        trt.scrollFactor.set(0,0);
        add(trt);


        trt2 = new FlxSprite().makeGraphic(18,10, FlxColor.WHITE, false);
        trt2.x = 2;
        trt2.y = 21;
        trt2.scrollFactor.set(0,0);
        add(trt2);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}