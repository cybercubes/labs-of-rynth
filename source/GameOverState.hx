package ;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxSubState;
class GameOverState extends FlxSubState
{
    var _restartBtn:FlxButton;
    var _mainMenuBtn:FlxButton;
    var _gameOverText:FlxText;

    override public function create():Void
    {
        super.create();

        _gameOverText = new FlxText(0,0,0, "Game Over", 30);
        _gameOverText.x = 65;
        _gameOverText.y = 70;
        _gameOverText.scrollFactor.set(0,0);
        add(_gameOverText);

        _restartBtn = new FlxButton(0, 0, "Restart", clickrestart);
        _restartBtn.x = 80;
        _restartBtn.y = 110;
        add(_restartBtn);

        _mainMenuBtn = new FlxButton(0, 0, "Main Menu", clickmain);
        _mainMenuBtn.x = 160;
        _mainMenuBtn.y = 110;
        add(_mainMenuBtn);

    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    function clickrestart():Void
    {
        FlxG.switchState(new PlayState());
    }

    function clickmain():Void
    {
        FlxG.switchState(new MenuState());
    }

}
