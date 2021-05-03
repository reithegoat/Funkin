package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class CyeIntroState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public var video:FlxSprite;
	public var instructions:FlxText;

	public var finished:Bool = false;


	override function create()
	{
		super.create();
		video = new FlxSprite();
		video.frames = Paths.getSparrowAtlas('CyeIntro');
		video.animation.addByPrefix('play','Timeline 1_',24,false);
		video.antialiasing = true;
		video.animation.play('play');
		add(video);


		instructions = new FlxText(5, FlxG.height - 24, 0, "Press enter to skip. Press escape to go back.", 12);
		instructions.scrollFactor.set();
		instructions.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(instructions);

		new FlxTimer().start(1.3,function(tmr:FlxTimer) {
			FlxG.sound.play(Paths.sound('cyeIncoming'));
		});

		new FlxTimer().start(11,function(tmr:FlxTimer) {
			if(!finished){
				finished = true;
				LoadingState.loadAndSwitchState(new PlayState(), true);
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && !finished)
		{
			finished = true;
			leftState = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
			FlxG.sound.play(Paths.sound('confirmMenu'));
		}
		if (controls.BACK && !finished)
		{
			finished = true;
			leftState = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.switchState(new MainMenuState());
			
		}
		super.update(elapsed);
	}

}
