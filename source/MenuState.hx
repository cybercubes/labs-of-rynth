package;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
    var _btnPlay:FlxButton;

    override public function create():Void
	{
		super.create();

        _btnPlay = new FlxButton(0, 0, "Play", clickplay);
        _btnPlay.screenCenter();
        add(_btnPlay);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

    function clickplay():Void
    {
        FlxG.switchState(new PlayState());
    }
}