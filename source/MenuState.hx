package;

import flixel.text.FlxText;
import flash.system.System;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG;

class MenuState extends FlxState
{
    var _btnPlay:FlxButton;
    var _optionsBtn:FlxButton;
    var _exitBtn:FlxButton;
    var _backGround:FlxBackdrop;
    var _titleTxt:FlxText;

    override public function create():Void
	{
		super.create();

        _backGround = new FlxBackdrop("assets/images/backGroundMainMenu.png");
        add(_backGround);

        _titleTxt = new FlxText(65, 30, 0, "Labs Of Rynth", 25);
        _titleTxt.scrollFactor.set(0);
        add (_titleTxt);

        _btnPlay = new FlxButton(0, 0, "Play", clickplay);
        _btnPlay.x = 120;
        _btnPlay.y = 90;
        add(_btnPlay);

        _optionsBtn = new FlxButton(0, 0, "Options", clickoptions);
        _optionsBtn.screenCenter();
        add(_optionsBtn);

        _exitBtn = new FlxButton(0, 0, "Exit", clickexit);
        _exitBtn.x = 120;
        _exitBtn.y = 130;
        add(_exitBtn);

        FlxG.camera.fade(FlxColor.BLACK, .33, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

    function clickplay():Void
    {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new PlayState());
        });
    }

    function clickoptions():Void
    {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new OptionsState());
        });
    }

    function clickexit():Void
    {
        System.exit(0);
    }
}