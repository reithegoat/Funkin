package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class CyeSlideshowState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public var frame:FlxSprite;
	public var frames:Array<String> = ["frame1","frame2","frame3","frame4","frame5","frame6","frame7"];
	public var currentIndex:Int = 0;

	public var instructions:FlxText;

	public var finished:Bool = false;


	override function create()
	{
		super.create();
		frame = new FlxSprite();
		frame.loadGraphic(Paths.image("cye intro/" + frames[0]));
		frame.setGraphicSize(1280,720);
		frame.screenCenter();
		frame.antialiasing = true;
		add(frame);


		instructions = new FlxText(5, FlxG.height - 24, 0, "Press enter to go to the next frame. Press escape to go back.", 12);
		instructions.scrollFactor.set();
		instructions.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(instructions);

		
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT && !finished)
		{
			if(currentIndex < frames.length-1){
				remove(frame);
				remove(instructions);
				currentIndex++;
				FlxG.sound.play(Paths.sound('scrollMenu'));
				frame = new FlxSprite();
				frame.loadGraphic(Paths.image("cye intro/"+ frames[currentIndex]));
				frame.setGraphicSize(1280,720);
				frame.screenCenter();
				frame.antialiasing = true;
				add(frame);
				instructions = new FlxText(5, FlxG.height - 24, 0, "Press enter to go to the next frame. Press escape to go back.", 12);
				instructions.scrollFactor.set();
				instructions.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				add(instructions);
			} else {
				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState(), true);
					});
				FlxG.sound.play(Paths.sound('confirmMenu'));
				finished = true;
			}
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
