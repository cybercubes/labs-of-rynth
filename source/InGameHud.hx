package ;
import actors.Player;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

class InGameHud extends FlxTypedGroup<FlxSprite>
{
   public var weaponSlot1:FlxSprite;
    public var weaponSlot2:FlxSprite;

    public function new()
    {
        super();

        weaponSlot1 = new FlxSprite().makeGraphic(18,10, FlxColor.WHITE, false);
        weaponSlot1.x = 2;
        weaponSlot1.y = 10;
        weaponSlot1.scrollFactor.set(0,0);
        add(weaponSlot1);


        weaponSlot2 = new FlxSprite().makeGraphic(18,10, FlxColor.WHITE, false);
        weaponSlot2.x = 2;
        weaponSlot2.y = 21;
        weaponSlot2.scrollFactor.set(0,0);
        add(weaponSlot2);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}