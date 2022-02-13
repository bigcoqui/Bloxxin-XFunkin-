package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.util.PNGEncoder;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.atlas.FlxAtlas;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import openfl.geom.Rectangle;
import lime.graphics.Image;
import haxe.io.Output;
import sys.io.FileOutput;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import flixel.ui.FlxButton;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import Math;

class PauseSubState extends MusicBeatSubstate
{
	// I have no idea why mouse input won't work here. I've tried everything I can LOL.

	var pauseMusic:FlxSound;
	var practiceText:FlxText;

	var mouseOn:FlxSprite;
	var mouseOff:FlxSprite;
	// var botplayText:FlxText;

	// Screen Assets
	var helpSection:FlxSprite;
	var recordText:FlxSprite;
	var recordButton:FlxButton;
	var reset:FlxButton;
	var leave:FlxButton;
	var resume:FlxButton;
	var tabBar:FlxSprite;
	var people:FlxButton;
	var settings:FlxButton;
	var help:FlxButton;
	var stats:FlxButton;
	var playerTile:FlxSprite;
	var volumeDown:FlxButton;
	var volumeUp:FlxButton;

	var topButtons:Array<FlxSprite> = [];
	var settingsInfo:Array<FlxText> = [];
	var settingsOptions:Array<FlxText> = [];
	var settingsAssets:Array<FlxSprite> = [];
	var settingsButtons:Array<FlxButton> = [];

	var playerTiles:Array<FlxSprite> = [];
	var playerNames:Array<FlxText> = [];
	var firstPlayer:Int;
	var lastPlayer:Int;

	var pauseCamera:FlxCamera = new FlxCamera();
	
	var diffLevels:Array<String> = CoolUtil.difficulties;
	var currentDiff:Int = PlayState.storyDifficulty;

	function botPlayTrigger()
	{
		PlayState.instance.botplayTxt.text = "BOTPLAY";
		PlayState.instance.practiceMode = false;
		PlayState.changedDifficulty = true;
		settingsOptions[5].text = "Disabled";
		if (PlayState.instance.cpuControlled == true)
		{
			PlayState.instance.cpuControlled = false;
			settingsOptions[0].text = "Disabled";
			PlayState.changedDifficulty = true;
			
		}
		else
		{
			PlayState.instance.cpuControlled = true;
			settingsOptions[0].text = "Enabled";
			PlayState.changedDifficulty = true;
		}
		
		PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
		PlayState.instance.botplayTxt.alpha = 1;
		PlayState.instance.botplaySine = 0;
	}

	function diffTriggerLeft()
	{
		currentDiff -= 1;
		if (currentDiff < 0)
			currentDiff = 2;

		resume.ID = 0;
		resume.loadGraphic(Paths.image("menupause/ResumeDenied"), false, 236, 58);
		settingsOptions[1].text = diffLevels[currentDiff];
		var nameSong:String = PlayState.SONG.song.toLowerCase();
		var formatting = Highscore.formatSong(nameSong, currentDiff);
		PlayState.SONG = Song.loadFromJson(formatting, nameSong);
		PlayState.storyDifficulty = currentDiff;
		CustomFadeTransition.nextCamera = transCamera;
		PlayState.changedDifficulty = true;
		PlayState.chartingMode = false;
	}

	function diffTriggerRight()
	{
		currentDiff += 1;
		if (currentDiff > 2)
			currentDiff = 0;
		
		resume.ID = 0;
		resume.loadGraphic(Paths.image("menupause/ResumeDenied"), false, 236, 58);
		settingsOptions[1].text = diffLevels[currentDiff];
		var nameSong:String = PlayState.SONG.song.toLowerCase();
		var formatting = Highscore.formatSong(nameSong, currentDiff);
		PlayState.SONG = Song.loadFromJson(formatting, nameSong);
		PlayState.storyDifficulty = currentDiff;
		CustomFadeTransition.nextCamera = transCamera;
		PlayState.changedDifficulty = true;
		PlayState.chartingMode = false;
	}

	function fullScreenTrigger()
	{
		if (FlxG.fullscreen == false)
		{
			FlxG.fullscreen = true;
			settingsOptions[2].text = "Enabled";
		}
		else
		{
			FlxG.fullscreen = false;
			settingsOptions[2].text = "Disabled";
		}
	}

	function antiAliasTrigger()
		{
			if (FlxG.save.data.globalAntialiasing == false)
			{
				FlxG.save.data.globalAntialiasing = true;
				settingsOptions[4].text = "Enabled";
			}
			else
			{
				FlxG.save.data.globalAntialiasing = false;
				settingsOptions[4].text = "Disabled";
			}

			FlxG.save.flush();
		}

	function practiceModeTrigger()
		{
			PlayState.instance.botplayTxt.text = "PRACTICE MODE";
			PlayState.instance.cpuControlled = false;
			settingsOptions[0].text = "Disabled";
			PlayState.changedDifficulty = true;
			if (PlayState.instance.practiceMode == false)
			{
				PlayState.instance.practiceMode = true;
				PlayState.changedDifficulty = true;
				settingsOptions[5].text = "Enabled";
			}
			else
			{
				PlayState.instance.practiceMode = false;
				PlayState.changedDifficulty = true;
				settingsOptions[5].text = "Disabled";
			}
			
			PlayState.instance.botplayTxt.visible = PlayState.instance.practiceMode;
			PlayState.instance.botplayTxt.alpha = 1;
			PlayState.instance.botplaySine = 0;
		}

	public static var transCamera:FlxCamera;

	public function new(x:Float, y:Float)
	{
		super();
		FlxG.plugins.add(new FlxMouseEventManager());

		pauseCamera.bgColor.alpha = 0;

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;
		mouseOn = new FlxSprite().loadGraphic(Paths.image("mouse_down"));
		mouseOff = new FlxSprite().loadGraphic(Paths.image("mouse_up"));
		FlxG.mouse.load(mouseOff.pixels);

		var topButtons = [people, settings, help, stats];

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		// Help Setup
		helpSection = new FlxSprite(0, 0).loadGraphic(Paths.image("menupause/HelpSection"));
		helpSection.updateHitbox();
		helpSection.alpha = 0;
		helpSection.antialiasing = true;
		add(helpSection);

		// Bottom Buttons
		function resetButton(){restartSong();};
		reset = new FlxButton(270, 630, "", resetButton);
		reset.loadGraphic(Paths.image("menupause/ResetCharacter"), false, 236, 58);
		reset.updateHitbox();
		reset.antialiasing = true;
		add(reset);	

		function quitButton()
		{
			PlayState.deathCounter = 0;
			PlayState.seenCutscene = false;
			if(PlayState.isStoryMode) {
				MusicBeatState.switchState(new StoryMenuState());
			} else {
				MusicBeatState.switchState(new FreeplayState());
			}
			FlxG.cameras.remove(PlayState.instance.camHUD);
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			PlayState.changedDifficulty = false;
			PlayState.chartingMode = false;
		};
		leave = new FlxButton(521, 630, "", quitButton);
		leave.loadGraphic(Paths.image("menupause/Leave"), false, 236, 58);
		leave.updateHitbox();
		leave.antialiasing = true;
		add(leave);

		function resumeButton()
		{
			if (resume.ID == 1)
			{
				close();
			}
		};
		resume = new FlxButton(775, 630, "", resumeButton);
		resume.ID = 1;
		resume.loadGraphic(Paths.image("menupause/Resume"), false, 236, 58);
		resume.updateHitbox();
		resume.antialiasing = true;
		add(resume);

		// Tabs for the Pause Menu!
		tabBar = new FlxSprite(270, 78).loadGraphic(Paths.image("menupause/TabBar"));
		tabBar.updateHitbox();
		tabBar.antialiasing = true;
		add(tabBar);

		function peopleButton()
			{
				
				stats.loadGraphic(Paths.image("menupause/STATS0002"));

				generatePlayersSection(true);
				generateHelpSection();
				generateSettingsSection();
			};
		people = new FlxButton(269, 92, "", peopleButton);
		people.loadGraphic(Paths.image("menupause/PEOPLE0001"));
		people.updateHitbox();
		people.antialiasing = true;
		add(people);

		function settingsButton()
			{

				
				stats.loadGraphic(Paths.image("menupause/STATS0002"));

				generatePlayersSection();
				generateHelpSection();
				generateSettingsSection(true);
			};
		settings = new FlxButton(455, 92, "", settingsButton);
		settings.loadGraphic(Paths.image("menupause/SETTINGS0002"));
		settings.updateHitbox();
		settings.antialiasing = true;
		add(settings);

		function helpButton()
			{
				

				stats.loadGraphic(Paths.image("menupause/STATS0002"));

				generatePlayersSection();
				generateHelpSection(true);
				generateSettingsSection();
			};
		help = new FlxButton(642, 91.5, "", helpButton);
		help.loadGraphic(Paths.image("menupause/HELP0002"));
		help.updateHitbox();
		help.antialiasing = true;
		add(help);

		function statsButton()
			{
				stats.loadGraphic(Paths.image("menupause/STATS0001"));

				generatePlayersSection();
				generateHelpSection();
				generateSettingsSection();
			};
		stats = new FlxButton(829, 92, "", statsButton);
		stats.loadGraphic(Paths.image("menupause/STATS0002"));
		stats.updateHitbox();
		stats.antialiasing = true;
		add(stats);

		generatePlayersSection(true);
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quadIn});

		FlxG.cameras.add(pauseCamera);
		help.cameras = [pauseCamera];
		helpSection.cameras = [pauseCamera];
		people.cameras = [pauseCamera];
		settings.cameras = [pauseCamera];
		tabBar.cameras = [pauseCamera];
		resume.cameras = [pauseCamera];
		reset.cameras = [pauseCamera];
		leave.cameras = [pauseCamera];
		bg.cameras = [pauseCamera];
		stats.cameras = [pauseCamera];

	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		if (FlxG.mouse.pressed)
		{
			FlxG.mouse.load(mouseOn.pixels);

		}
		else if (FlxG.mouse.justReleased)
		{
			FlxG.mouse.load(mouseOff.pixels);
		}

		if (FlxG.mouse.wheel != 0 && playerTiles.length > 6)
		{
			if (FlxG.mouse.wheel > 0)
			{
				if (playerTiles[lastPlayer + 1] != null)
				{
					for (i in firstPlayer ... lastPlayer)
					{
						remove(playerTiles[i]);
						remove(playerNames[i]);
					}
					firstPlayer += 1;
					lastPlayer += 1;
					for (i in 0 ... playerTiles.length)
					{
						playerTiles[i].y -= 73;
						playerNames[i].y -= 73;
					}

					for (i in firstPlayer ... lastPlayer)
					{
						add(playerTiles[i]);
						add(playerNames[i]);
					}
				}
			}
			else
			{
				if (playerTiles[firstPlayer - 1] != null)
				{
					for (i in firstPlayer ... lastPlayer)
					{
						remove(playerTiles[i]);
						remove(playerNames[i]);
					}
					firstPlayer -= 1;
					lastPlayer -= 1;
					for (i in 0 ... playerTiles.length)
					{
						playerTiles[i].y += 73;
						playerNames[i].y += 73;
					}

					for (i in firstPlayer ... lastPlayer)
					{
						add(playerTiles[i]);
						add(playerNames[i]);
					}
				}
			}
		}

		super.update(elapsed);
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
		FlxG.cameras.remove(PlayState.instance.camHUD);
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function resetDown(spr:FlxSprite):Void
	{
		restartSong();
	}

	function generateHelpSection(opened:Bool = false)
	{
		if (!opened)
		{
			help.loadGraphic(Paths.image("menupause/HELP0002"));
			helpSection.alpha = 0;
		}
		else
		{
			help.loadGraphic(Paths.image("menupause/HELP0001"));
			helpSection.alpha = 1;
		}
	}

	function generatePlayersSection(opened:Bool = false)
	{
		if (!opened)
		{
			var players:Array<String> = [];
			people.loadGraphic(Paths.image("menupause/PEOPLE0002"));
			if (playerTiles.length > 0)
			{
				for (tile in playerTiles)
				{
					tile.destroy();
				}

				for (name in playerNames)
				{
					remove(name);
				}
			}

			playerTiles = [];
			playerNames = [];
		}
		else
		{
			var players:Array<String> = [];
			people.loadGraphic(Paths.image("menupause/PEOPLE0001"));
			if (playerTiles.length > 0)
			{
				for (tile in playerTiles)
				{
					tile.destroy();
				}

				for (name in playerNames)
				{
					remove(name);
				}
			}

			playerTiles = [];
			playerNames = [];

			switch (PlayState.curStage)
			{
				case 'funkyfriday':
					players = ["Boy", "Girl", "Noob"];
				case 'bloxburg':
					players = ["Boy", "Girl", "Guest0666"];
				case 'livetopia':
					players = ["Bacon", "Borapaws", "DavedocCom", "dieland040", "Girl", "ImDaBroblox", "jakersfakers", "kidwither2",
							   "letsgotoashark", "marvelstan200", "Noob", "rylord25", "The_AlmightlyCarlito", "Unkn0wnAcc0unts"];
				case 'pizzaplace':
					players = ["AweIsWatching", "baconroller_co", "bado15", "Boy", "Girl", "GodGamingMoment", "hoppopdig", "iiCJP", "kingkong80970",
							   "mrawesome99999999991", "muzyka78", "ninjascoot147", "SonikkuFANMADE", "Zeff111"];
					
			}

			var playerY:Int = 144;
			firstPlayer = 0;
			lastPlayer = players.indexOf(players[-1]);
			if (players.length > 6)
			{
				lastPlayer = 6;
			}
			for (player in players)
			{
				var playerText:FlxText = new FlxText(321, playerY, 0, player, 24);
				playerTile = new FlxSprite(266, playerY).loadGraphic(Paths.image("menupause/PlayerBG"));
				playerText.font = 'assets/fonts/Gadugi.ttf';
				playerTile.updateHitbox();
				playerText.updateHitbox();
				playerTile.antialiasing = true;
				if (players.indexOf(player) < 6)
				{
					add(playerTile);
					add(playerText);
				}
				playerTiles.push(playerTile);
				playerNames.push(playerText);
				playerTile.cameras = [pauseCamera];
				playerText.cameras = [pauseCamera];
				playerY += 73;
			}
		}
	}

	function generateSettingsSection(opened:Bool = false)
	{
		if (!opened)
		{
			settings.loadGraphic(Paths.image("menupause/SETTINGS0002"));
			if (settingsInfo.length > 0)
			{
				for (item in settingsInfo)
				{
					remove(item);
				}

				for (item in settingsButtons)
				{
					remove(item);
				}

				for (item in settingsAssets)
				{
					item.destroy();
				}

				for (item in settingsOptions)
				{
					remove(item);
				}
			}
			
			settingsInfo = [];
			settingsButtons = [];
			settingsAssets = [];
			settingsOptions = [];
		}
		else
		{
			settings.loadGraphic(Paths.image("menupause/SETTINGS0001"));
			if (settingsInfo.length > 0)
			{
				for (item in settingsInfo)
				{
					remove(item);
				}

				for (item in settingsButtons)
				{
					remove(item);
				}

				for (item in settingsAssets)
				{
					remove(item);
				}

				for (item in settingsOptions)
				{
					remove(item);
				}
			}
			
			settingsInfo = [];
			settingsButtons = [];
			settingsAssets = [];
			settingsOptions = [];

			var optionList:Array<String> = ["Botplay", "Difficulty", "Fullscreen", "Volume", "Antialiasing", "Practice Mode"];
			var textChoice:Array<String> = ["Disabled", diffLevels[PlayState.storyDifficulty], "Disabled", "", "Enabled", "Disabled"];
			var optionY:Float = 157;
			var arrowY:Float = 102;
			var textY:Float = 157;
			var boxY:Float = 143;
			var settingsBar:FlxSprite;
			var optionText:FlxText;
			var choiceText:FlxText;

			for (option in optionList)
			{
				settingsBar = new FlxSprite(269, boxY).loadGraphic(Paths.image("menupause/SettingsOptionBG"));
				optionText = new FlxText(281, optionY, 0, option, 16, true);
				optionText.font = 'assets/fonts/FranklinGothicMediumCondRegular.ttf';
				add(settingsBar);
				add(optionText);
				settingsAssets.push(settingsBar);
				settingsInfo.push(optionText);
				settingsBar.cameras = [pauseCamera];
				optionText.cameras = [pauseCamera];
				optionY += 47;
				boxY += 47;
				var optionLeftX:Int = 581;
				var optionRightX:Int = 985;

				var optionLeft:FlxButton = new FlxButton(optionLeftX, optionY - 52, "", botPlayTrigger);
				var optionRight:FlxButton = new FlxButton(optionRightX, optionY - 52, "", botPlayTrigger);
				choiceText = new FlxText(774, textY, 0, textChoice[optionList.indexOf(option)], 16, true);
				switch (optionList.indexOf(option))
				{
					case 0:
					{
						optionLeft = new FlxButton(optionLeftX, optionY - 52, "", botPlayTrigger);
						optionRight = new FlxButton(optionRightX, optionY - 52, "", botPlayTrigger);
						if (PlayState.instance.cpuControlled == true)
						{
							choiceText.text = "Enabled";
						}
					}
					case 1:
					{
						optionLeft = new FlxButton(optionLeftX, optionY - 52, "", diffTriggerLeft);
						optionRight = new FlxButton(optionRightX, optionY - 52, "", diffTriggerRight);
						if (PlayState.instance.cpuControlled == true)
						{
							choiceText.text = "Enabled";
						}
					}
					case 2:
					{
						optionLeft = new FlxButton(optionLeftX, optionY - 52, "", fullScreenTrigger);
						optionRight = new FlxButton(optionRightX, optionY - 52, "", fullScreenTrigger);
						if (FlxG.fullscreen == true)
						{
							choiceText.text = "Enabled";
						}
					}
					case 4:
					{
						optionLeft = new FlxButton(optionLeftX, optionY - 52, "", antiAliasTrigger);
						optionRight = new FlxButton(optionRightX, optionY - 52, "", antiAliasTrigger);
						if (FlxG.save.data.globalAntialiasing == true)
						{
							choiceText.text = "Enabled";
						}
					}
					case 5:
					{
						optionLeft = new FlxButton(optionLeftX, optionY - 52, "", practiceModeTrigger);
						optionRight = new FlxButton(optionRightX, optionY - 52, "", practiceModeTrigger);
						if (PlayState.instance.practiceMode == true)
						{
							choiceText.text = "Enabled";
						}
					}
				}
				
				optionLeft.loadGraphic(Paths.image("menupause/OptionLeft"));
				optionRight.loadGraphic(Paths.image("menupause/OptionRight"));
				optionLeft.updateHitbox();
				optionRight.updateHitbox();
				optionLeft.antialiasing = true;
				optionRight.antialiasing = true;
				optionLeft.cameras = [pauseCamera];
				optionRight.cameras = [pauseCamera];
				settingsAssets.push(optionLeft);
				settingsAssets.push(optionRight);
				add(optionLeft);
				add(optionRight);
				choiceText.font = 'assets/fonts/FranklinGothicMediumCondRegular.ttf';
				settingsOptions.push(choiceText);
				choiceText.cameras = [pauseCamera];
				add(choiceText);
				textY += 47;
				arrowY += 47;

				if (optionList.indexOf(option) == 3)
				{
					remove(choiceText);
					remove(optionRight);
					remove(optionLeft);
				}
			}

			var volumeBar:FlxSprite = new FlxSprite(616, 296);
			volumeBar.frames = Paths.getSparrowAtlas("menupause/VolumeBar");
			for (i in 0 ... 11)
			{
				volumeBar.animation.addByIndices(Std.string(i / 10), "VOLUMEBAR", [i], "", 1, true);
			}
			volumeBar.animation.play(Std.string(Math.round(FlxG.sound.volume * 10) / 10));
			settingsAssets.push(volumeBar);
			volumeBar.cameras = [pauseCamera];
			add(volumeBar);

			function vDown() 
			{
				if (FlxG.sound.volume > 0) 
				{
					FlxG.sound.volume -= 0.1; 
					volumeBar.animation.play(Std.string(FlxG.sound.volume));
				}
			}
			function vUp()
			{
				if (FlxG.sound.volume < 1)
				{
					FlxG.sound.volume += 0.1; 
					volumeBar.animation.play(Std.string(FlxG.sound.volume));
				}
			}
			volumeDown = new FlxButton(578, 294, "", vDown);
			volumeDown.cameras = [pauseCamera];
			volumeDown.loadGraphic(Paths.image("menupause/VolumeDown"));
			volumeDown.updateHitbox();
			volumeDown.antialiasing = true;
			settingsButtons.push(volumeDown);
			add(volumeDown);
			volumeUp = new FlxButton(980, 294, "", vUp);
			volumeUp.cameras = [pauseCamera];
			volumeUp.loadGraphic(Paths.image("menupause/VolumeUp"));
			volumeUp.updateHitbox();
			volumeUp.antialiasing = true;
			settingsButtons.push(volumeUp);
			add(volumeUp);
		}
	}
}
