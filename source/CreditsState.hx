package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class CreditsState extends MusicBeatState
{
	public static var leftState:Bool = false;

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
			"The people that made this week possible:\n\n"
			+ "UniBrine - Artist, Character Designer, Animator\n"
			+ "Rei the Goat - Programmer"
			+ "Avocado Tunes - Composer\n"
			+ "Ilker - Co-Musician\n"
			+ "DaDrawingLad - Charter\n"
			+ "Irascor - Sketch Artist, Animator, Tutorial BG Artist\n"
			+ "Sipkyy - Background Artist\n"
			+ "Neto - Original Background Artist\n"
			+ "Linuxydable - Intro Animation Algorithm Help\n\n"
			+ "KadeDev - Kade Engine Developer\n"
			+ "ninjamuffin99 - FNF' Developer\n"
			+ "NyxTheShield - FNF Boyfriend Soundfont\n",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			leftState = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
		}
		super.update(elapsed);
	}
}
