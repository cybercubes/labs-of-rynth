package ;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.ui.FlxButton;
class PauseState extends FlxSubState
{
    var _resumeBtn:FlxButton;
    var _mainMenuBtn:FlxButton;

    override public function create():Void
    {
        super.create();

        _resumeBtn = new FlxButton(0, 0, "Resume", clickresume);
        _resumeBtn.x = 120;
        _resumeBtn.y = 90;
        add(_resumeBtn);

        _mainMenuBtn = new FlxButton(0, 0, "Main Menu", clickmain);
        _mainMenuBtn.screenCenter();
        add(_mainMenuBtn);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    function clickresume():Void
    {
        FlxG.switchState(new PlayState());
    }

    function clickmain():Void
    {
        FlxG.switchState(new MenuState());
    }

}
