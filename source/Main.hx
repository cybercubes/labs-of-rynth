package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(320, 240, MenuState));

		var _save:FlxSave = new FlxSave();
		_save.bind("SettingsSave");

		if (_save.data.volume != null)
		{
			FlxG.sound.volume = _save.data.volume;
		}

		if (_save.data.fullcreen != false)
		{
			FlxG.fullscreen = _save.data.fullscreen;
		}
		_save.close();
	}
}
