package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class OutdatedState extends MusicBeatState
{
	public static var needVer:String;

	override function create()
	{
		super.create();
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("menuBG"));

		//menuBG.color = FlxColor.BLUE;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"This version of Cye Weeks is OUTDATED!\n\n"
			+ "Press ENTER/RETURN to go to the GameBanana page.\n"
			+ "Press ESCAPE to ignore this message.\n\n"
			+ "Current Version is v" + MainMenuState.gameVer + ".\n"
			+ "New Version is v" + needVer + ".",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxG.openURL("https://gamebanana.com/mods/166624");
		}
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
