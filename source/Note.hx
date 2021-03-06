package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	
	public var listenBadNotes:Bool = false;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;
	
	public var isAlt:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	
	public var isDownscroll:Bool = false;

	public function new(isDownscroll:Bool, strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();
		
		this.isDownscroll = isDownscroll;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;
		this.strumTime = strumTime;

		this.noteData = noteData;

		var daStage:String = PlayState.curStage;

		switch (daStage)
		{
			case 'school' | 'schoolEvil':
				//changed the animated shit
				loadGraphic(Paths.image('weeb/pixelUI/arrows-pixels'), true, 17, 17);

				if (isDownscroll)
				{
				animation.add('greenScroll', [6], 30, true, true, true);
				animation.add('redScroll', [7], 30, true, true, true);
				animation.add('blueScroll', [5], 30, true, true, true);
				animation.add('purpleScroll', [4], 30, true, true, true);
				} else {
				animation.add('greenScroll', [6]);
				animation.add('redScroll', [7]);
				animation.add('blueScroll', [5]);
				animation.add('purpleScroll', [4]);
				}

				if (isSustainNote)
				{
					loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					if (isDownscroll)
					{
					animation.add('purpleholdend', [4], 30, true, true, false);
					animation.add('greenholdend', [6], 30, true, true, false);
					animation.add('redholdend', [7], 30, true, true, false);
					animation.add('blueholdend', [5], 30, true, true, false);

					animation.add('purplehold', [0], 30, true, true, true);
					animation.add('greenhold', [2], 30, true, true, true);
					animation.add('redhold', [3], 30, true, true, true);
					animation.add('bluehold', [1], 30, true, true, true);
					} else {
					animation.add('purpleholdend', [4]);
					animation.add('greenholdend', [6]);
					animation.add('redholdend', [7]);
					animation.add('blueholdend', [5]);

					animation.add('purplehold', [0]);
					animation.add('greenhold', [2]);
					animation.add('redhold', [3]);
					animation.add('bluehold', [1]);
					}
				}

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();

			default:
				if (PlayState.SONG.song.toLowerCase() == 'genocide')
				{
					frames = Paths.getSparrowAtlas('tabi/mad/NOTE_assets', 'curse');
				} else {
					frames = Paths.getSparrowAtlas('NOTE_assets', 'shared');
				}

				if (isDownscroll)
				{
				animation.addByPrefix('greenScroll', 'green0', 30, true, true, true);
				animation.addByPrefix('redScroll', 'red0', 30, true, true, true);
				animation.addByPrefix('blueScroll', 'blue0', 30, true, true, true);
				animation.addByPrefix('purpleScroll', 'purple0', 30, true, true, true);

				animation.addByPrefix('purpleholdend', 'pruple end hold', 30, true, true, false);
				animation.addByPrefix('greenholdend', 'green hold end', 30, true, true, false);
				animation.addByPrefix('redholdend', 'red hold end', 30, true, true, false);
				animation.addByPrefix('blueholdend', 'blue hold end', 30, true, true, false);

				animation.addByPrefix('purplehold', 'purple hold piece', 30, true, true, false);
				animation.addByPrefix('greenhold', 'green hold piece', 30, true, true, false);
				animation.addByPrefix('redhold', 'red hold piece', 30, true, true, false);
				animation.addByPrefix('bluehold', 'blue hold piece', 30, true, true, false);
				} else {
				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');
				}

				setGraphicSize(Std.int(width * 0.7));
				updateHitbox();
				antialiasing = true;
		}

		switch (noteData)
		{
			case 0:
				x += swagWidth * 0;
				animation.play('purpleScroll');
			case 1:
				x += swagWidth * 1;
				animation.play('blueScroll');
			case 2:
				x += swagWidth * 2;
				animation.play('greenScroll');
			case 3:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		// trace(prevNote);

		if (isSustainNote && prevNote != null)
		{
			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			switch (noteData)
			{
				case 2:
					animation.play('greenholdend');
				case 3:
					animation.play('redholdend');
				case 1:
					animation.play('blueholdend');
				case 0:
					animation.play('purpleholdend');
			}

			updateHitbox();

			x -= width / 2;

			if (PlayState.curStage.startsWith('school'))
				x += 30;

			if (prevNote.isSustainNote)
			{
				switch (prevNote.noteData)
				{
					case 0:
						prevNote.animation.play('purplehold');
					case 1:
						prevNote.animation.play('bluehold');
					case 2:
						prevNote.animation.play('greenhold');
					case 3:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
				prevNote.updateHitbox();
				// prevNote.setGraphicSize();
			}
		}
	}
	
	public function inverseX():Void
	{
		if (isDownscroll)
		{
			x = FlxG.width - x - width;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (mustPress)
		{
			var multiplier1:Float = 1;
			var multiplier2:Float = 0.5;
			var multiplier1Orig:Float = 1;
			var multiplier2Orig:Float = 0.5;
			if (Highscore.getInput())
			{
				multiplier1 = 4;
				multiplier2 = 0.85;
			}
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * multiplier1)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * multiplier2))
				canBeHit = true;
			else
				canBeHit = false;
				
			if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * multiplier1Orig)
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * multiplier2Orig))
				listenBadNotes = true;
			else
				listenBadNotes = false;

			/*if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;*/
				//NOT NEEDED FOR DOWNSCROLL LOL
				//actually nevermind
			if (strumTime < Conductor.songPosition - (Conductor.safeZoneOffset * multiplier1) && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
