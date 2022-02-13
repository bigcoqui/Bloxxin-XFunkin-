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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import Achievements;

using StringTools;

class AchievementsMenuState extends MusicBeatState
{
	var options:Array<String> = [];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	private var achievementArray:Array<AttachedAchievement> = [];
	private var achievementIndex:Array<Int> = [];
	private var descText:FlxText;

	override function create() 
	{
		FlxG.mouse.visible = true;
		FlxG.mouse.enabled = true;
		FlxG.mouse.load(TitleState.mouseOff.pixels);

		#if desktop
		DiscordClient.changePresence("Achievements Menu", null);
		#end

		var bg:FlxSprite = MenuConstants.generateBG();
		add(bg);

		var menu:FlxTypedGroup<FlxSprite> = MenuConstants.generateMenu();
		add(menu);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var text:FlxSprite = new FlxSprite(138, 42).loadGraphic(Paths.image("mainmenu/text2"));
		text.antialiasing = ClientPrefs.globalAntialiasing;
		add(text);

		for (i in 0...Achievements.achievementsStuff.length) {
			if(!Achievements.achievementsStuff[i][3] || Achievements.achievementsMap.exists(Achievements.achievementsStuff[i][2])) {
				options.push(Achievements.achievementsStuff[i]);
				achievementIndex.push(i);
			}
		}

		var iconX:Int = 143;
		var iconY:Int = 63;
		for (i in 0...options.length) {
			var achieveName:String = Achievements.achievementsStuff[achievementIndex[i]][2];

			var icon:AttachedAchievement = new AttachedAchievement(iconX, 63, achieveName);
			icon.ID = i;
			FlxMouseEventManager.add(icon, null, null, viewAchievement, unviewAchievement);
			achievementArray.push(icon);
			add(icon);

			iconX += 110;
		}

		descText = new FlxText(150, 600, 980, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.pressed)
		{
			FlxG.mouse.load(TitleState.mouseOn.pixels);
		}
		else if (FlxG.mouse.justReleased)
		{
			FlxG.mouse.load(TitleState.mouseOff.pixels);
		}
	}

	function viewAchievement(spr:FlxSprite)
	{
		FlxTween.tween(spr.scale, {x: 1.1, y: 1.1}, 0.25, {ease: FlxEase.backOut});
		FlxTween.tween(spr, {angle: 10}, 0.25, {ease: FlxEase.backOut});
		descText.text = Achievements.achievementsStuff[achievementIndex[spr.ID]][1];
		if (Achievements.achievementsMap.exists(Achievements.achievementsStuff[spr.ID][2]))
		{
			descText.text = Achievements.achievementsStuff[achievementIndex[spr.ID]][0] + "\n\n" + Achievements.achievementsStuff[achievementIndex[spr.ID]][1];
		}
	}

	function unviewAchievement(spr:FlxSprite)
	{
		FlxTween.tween(spr.scale, {x: 1, y: 1}, 0.25, {ease: FlxEase.backIn});
		FlxTween.tween(spr, {angle: 0}, 0.25, {ease: FlxEase.backIn});
		descText.text = "";
	}
}
