package ;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxState;

class OptionsState extends FlxState
{
    //All Options Buttons and Text
    var _optionsTitle:FlxText;
    var _volumeBar:FlxBar;
    var _volumeTxt:FlxText;
    var _volumeAmtTxt:FlxText;
    var _volumeUpBtn:FlxButton;
    var _volumeDownBtn:FlxButton;
    var _defaultSettingsBtn:FlxButton;
    var _mainMenuBtn:FlxButton;
    var _fullScreenButton:FlxButton;

    //This is for Saving Changes
    var _save:FlxSave;

    override public function create():Void
    {
        super.create();

        _optionsTitle = new FlxText(120, 20, 0, "Options", 22);
        add(_optionsTitle);

        _volumeTxt = new FlxText(_optionsTitle.x + 30, _optionsTitle.y + _optionsTitle.height + 10, 0, "Volume", 8);
        add (_volumeTxt);

        _volumeDownBtn = new FlxButton(8, _volumeTxt.y + _volumeTxt.height + 2, " -", clickVolumeDown);
        _volumeDownBtn.loadGraphic("assets/images/button.png", true, 20, 20);
        _volumeDownBtn.onUp.sound = FlxG.sound.load("assets/sounds/buttonDown.wav");
        add (_volumeDownBtn);

        _volumeUpBtn = new FlxButton(FlxG.width - 28,_volumeDownBtn.y," +", clickVolumeUp);
        _volumeUpBtn.loadGraphic("assets/images/button.png", true, 20, 20);
        _volumeUpBtn.onUp.sound = FlxG.sound.load("assets/sounds/buttonUp.wav");
        add (_volumeUpBtn);

        _volumeBar = new FlxBar(_volumeDownBtn.x + _volumeDownBtn.width + 4, _volumeDownBtn.y, LEFT_TO_RIGHT, Std.int(FlxG.width - 64), Std.int(_volumeUpBtn.height));
        _volumeBar.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
        add (_volumeBar);

        _volumeAmtTxt = new FlxText(155, 0, 200, (FlxG.sound.volume * 100) + "%", 8);
        _volumeAmtTxt.borderStyle = FlxTextBorderStyle.OUTLINE;
        _volumeAmtTxt.borderColor = 0xff464646;
        _volumeAmtTxt.y = _volumeBar.y + (_volumeBar.height / 2) - (_volumeAmtTxt.height / 2);
        add (_volumeAmtTxt);

        _fullScreenButton = new FlxButton(130, _volumeBar.y + _volumeBar.height + 8, FlxG.fullscreen ? "FullScreen" : "Windowed", clickfullscreen);
        add (_fullScreenButton);

        _defaultSettingsBtn = new FlxButton((FlxG.width / 2) - 90, FlxG.height - 28, "Default", clickDefaultSettings);
        add (_defaultSettingsBtn);

        _mainMenuBtn = new FlxButton((FlxG.width / 2) + 10, FlxG.height - 28, "Back", clickBack);
        add (_mainMenuBtn);

        // Save
        _save = new FlxSave();
        _save.bind("flixel-tutorial");

        updateVolume();

        FlxG.camera.fade(FlxColor.BLACK, .33, true);
    }

    function clickfullscreen():Void
    {
        FlxG.fullscreen = !FlxG.fullscreen;
        _fullScreenButton.text = FlxG.fullscreen ? "FullScreen" : "Windowed";
        _save.data.fullscreen = FlxG.fullscreen;
    }

    function clickDefaultSettings():Void
    {
        _save.erase();
        FlxG.sound.volume = .5;
        updateVolume();
    }

    function clickBack():Void
    {
        _save.close();
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new MenuState());
        });
    }

    function clickVolumeDown():Void
    {
        FlxG.sound.volume -= 0.1;
        _save.data.volume = FlxG.sound.volume;
        updateVolume();
    }

    function clickVolumeUp():Void
    {
        FlxG.sound.volume += 0.1;
        _save.data.volume = FlxG.sound.volume;
        updateVolume();
    }

    function updateVolume():Void
    {
        var volume:Int = Math.round(FlxG.sound.volume * 100);
        _volumeBar.value = volume;
        _volumeAmtTxt.text = volume + "%";
    }
}
