package ;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.ui.FlxButton;
class PauseState extends FlxSubState
{
    var _resumeBtn:FlxButton;
    var _mainMenuBtn:FlxButton;
    var _restartBtn:FlxButton;

    override public function create():Void
    {
        super.create();

        _resumeBtn = new FlxButton(0, 0, "Resume", clickresume);
        _resumeBtn.x = 120;
        _resumeBtn.y = 70;
        add(_resumeBtn);

        _restartBtn = new FlxButton(0, 0, "Restart", clickrestart);
        _restartBtn.x = 120;
        _restartBtn.y = 90;
        add(_restartBtn);

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
        close();
    }

    function clickrestart():Void
    {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new PlayState());
        });
    }

    function clickmain():Void
    {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new MenuState());
        });
    }

}
