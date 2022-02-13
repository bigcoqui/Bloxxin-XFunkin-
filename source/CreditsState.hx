package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var textNames:FlxTypedGroup<FlxText>;
	private var iconArray:FlxTypedGroup<FlxSprite>;
	private var creditsStuff:Array<Array<String>> = [];

	var descText:FlxText;

	override function create()
	{
		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;
		FlxG.mouse.load(TitleState.mouseOff.pixels);
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		var bg:FlxSprite = MenuConstants.generateBG();
		add(bg);
		
		var cred:FlxSprite = MenuConstants.generateCredits();
		add(cred);

		var menu:FlxTypedGroup<FlxSprite> = MenuConstants.generateMenu();
		add(menu);


		textNames = new FlxTypedGroup<FlxText>();
		add(textNames);

		iconArray = new FlxTypedGroup<FlxSprite>();
		add(iconArray);

		#if MODS_ALLOWED
		//trace("finding mod shit");
		for (folder in Paths.getModDirectories())
		{
			var creditsFile:String = Paths.mods(folder + '/data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		};
		var folder = "";
			var creditsFile:String = Paths.mods('data/credits.txt');
			if (FileSystem.exists(creditsFile))
			{
				var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
				}
				creditsStuff.push(['']);
			}
		#end

		var pisspoop:Array<Array<String>> = [ //Name - Icon name - Description - Link - BG Color
			// modder
			['AbraX',				'abrax',			"Dev, Artist, Animator, Character, Composer of\n Bloxxin'XFunkin'", 'https://www.roblox.com/users/33048062/profile', 'FFFFFF'],
			// psych engine
			['Shadow Mario',		'shadowmario',		'Main Programmer of Psych Engine',						'https://twitter.com/Shadow_Mario_',	'444444'],
			['RiverOaken',			'riveroaken',		'Main Artist/Animator of Psych Engine',					'https://twitter.com/river_oaken',		'C30085'],
			['bb-panzu',			'bb-panzu',			'Additional Programmer of Psych Engine',				'https://twitter.com/bbsub3',			'389A58'],
			// contributions
			['shubs',				'shubs',			'New Input System Programmer',							'https://twitter.com/yoshubs',			'4494E6'],
			['SqirraRNG',			'gedehari',			'Chart Editor\'s Sound Waveform base',					'https://twitter.com/gedehari',			'FF9300'],
			['iFlicky',				'iflicky',			'Delay/Combo Menu Song Composer\nand Dialogue Sounds',	'https://twitter.com/flicky_i',			'C549DB'],
			['PolybiusProxy',		'polybiusproxy',	'.MP4 Video Loader Extension',							'https://twitter.com/polybiusproxy',	'FFEAA6'],
			['Keoiki',				'keoiki',			'Note Splash Animations',								'https://twitter.com/Keoiki_',			'FFFFFF'],
			// original
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",					'https://twitter.com/ninja_muffin99',	'F73838'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",						'https://twitter.com/PhantomArcade3K',	'FFBB1B'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",						'https://twitter.com/evilsk8r',			'53E52C'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",						'https://twitter.com/kawaisprite',		'6475F3']
		];
		
		for(i in pisspoop){
			creditsStuff.push(i);
		}
	
		var iconX:Int = 200;
		var iconY:Int = 100;
		for (i in 0...creditsStuff.length)
		{
			var icon:FlxSprite = new FlxSprite(iconX, iconY).loadGraphic(Paths.image('credits/' + creditsStuff[i][1]));
			icon.ID = i;
			FlxMouseEventManager.add(icon, null, null, hoverIcon, unhoverIcon);
			iconArray.add(icon);

			var iconName:FlxText = new FlxText(iconX, iconY + icon.height, 0, creditsStuff[i][0], false);
			iconName.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			iconName.borderSize = 1.5;
			textNames.add(iconName);
			iconName.x += (icon.width - iconName.width) / 2;

			iconX += 200;
			if (i % 5 == 4)
			{
				iconY += 175;
				iconX = 200;
			}
		}

		descText = new FlxText(50, 625, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);
		
		super.create();
	}

	function hoverIcon(spr:FlxSprite)
	{
		FlxTween.tween(spr.scale, {x: 1.1, y: 1.1}, 0.25, {ease: FlxEase.backOut});
		FlxTween.tween(spr, {angle: 15}, 0.25, {ease: FlxEase.backOut});
		descText.text = creditsStuff[spr.ID][2];
	}

	function unhoverIcon(spr:FlxSprite)
	{
		FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.backIn});
		FlxTween.tween(spr, {angle: 0}, 0.25, {ease: FlxEase.backIn});
		descText.text = "";
	}

	function clickIcon(spr:FlxSprite)
	{
		CoolUtil.browserLoad(creditsStuff[spr.ID][3]);
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.mouse.pressed)
		{
			FlxG.mouse.load(TitleState.mouseOn.pixels);
		}
		else if (FlxG.mouse.justReleased)
		{
			FlxG.mouse.load(TitleState.mouseOff.pixels);
		}
		super.update(elapsed);
	}
}