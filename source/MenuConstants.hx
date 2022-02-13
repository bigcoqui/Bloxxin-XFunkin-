package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MenuConstants extends FlxSprite
{
    public static function generateMenu()
    {
		var optionShit:Array<String> = [
			'Home',
			'Freeplay',
			'Friends',
			'Profile',
			'Extras',
			#if !switch 'Donate', #end
			'Credits',
			'Polls',
			#if ACHIEVEMENTS_ALLOWED 'Badges' #end
		];

		var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	 	var logo:FlxSprite;
	 	var nameLeft:FlxSprite;
	 	var nameRight:FlxSprite;
	 	var settings:FlxSprite;
	 	var age:FlxSprite;
	 	var notifs:FlxSprite;
	 	var robux:FlxSprite;
     	var thisItem:FlxSprite;

		function pressedHome(spr:FlxSprite)
		{
			MusicBeatState.switchState(new MainMenuState(), true);
		}
	
		function pressedFreeplay(spr:FlxSprite)
		{
			MusicBeatState.switchState(new FreeplayState(), true);
		}
	
		function pressedDonate(spr:FlxSprite)
		{
			CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
		}
	
		function pressedCredits(spr:FlxSprite)
		{
			MusicBeatState.switchState(new CreditsState(), true);
		}
	
		function pressedBadges(spr:FlxSprite)
		{
			MusicBeatState.switchState(new AchievementsMenuState(), true);
		}
	
		function pressedSettings(spr:FlxSprite)
		{
			MusicBeatState.switchState(new options.OptionsState(), true);
		}

		for (i in 0...optionShit.length)
		{
			thisItem = new FlxSprite(12, 76 + (24 * i)).loadGraphic(Paths.image('mainmenu/buttons/' + optionShit[i]));
			thisItem.antialiasing = ClientPrefs.globalAntialiasing;
			thisItem.ID = i;
			menuItems.add(thisItem);
			thisItem.updateHitbox();
		}

		logo = new FlxSprite(7, 2).loadGraphic(Paths.image('mainmenu/buttons/Logo'));
		logo.ID = 9;
		menuItems.add(logo);
		logo.antialiasing = ClientPrefs.globalAntialiasing;

		nameRight = new FlxSprite(992, 5).loadGraphic(Paths.image('mainmenu/buttons/Username'));
		nameRight.ID = 10;
		menuItems.add(nameRight);
		nameRight.antialiasing = ClientPrefs.globalAntialiasing;

		nameLeft = new FlxSprite(10, 39).loadGraphic(Paths.image('mainmenu/buttons/Username2'));
		nameLeft.ID = 11;
		menuItems.add(nameLeft);
		nameLeft.antialiasing = ClientPrefs.globalAntialiasing;

		settings = new FlxSprite(1233, 7).loadGraphic(Paths.image('mainmenu/buttons/Settings'));
		settings.ID = 12;
		menuItems.add(settings);
		settings.antialiasing = ClientPrefs.globalAntialiasing;

		age = new FlxSprite(1105, 13).loadGraphic(Paths.image('mainmenu/buttons/Age'));
		age.ID = 13;
		menuItems.add(age);
		age.antialiasing = ClientPrefs.globalAntialiasing;

		notifs = new FlxSprite(1133, 8).loadGraphic(Paths.image('mainmenu/buttons/Notifs'));
		notifs.ID = 14;
		menuItems.add(notifs);
		notifs.antialiasing = ClientPrefs.globalAntialiasing;

		robux = new FlxSprite(1168, 7).loadGraphic(Paths.image('mainmenu/buttons/Robux'));
		robux.ID = 15;
		menuItems.add(robux);
		robux.antialiasing = ClientPrefs.globalAntialiasing;

		FlxMouseEventManager.add(nameRight, pressedHome, null, null, null);
		FlxMouseEventManager.add(nameLeft, pressedHome, null, null, null);
		FlxMouseEventManager.add(logo, pressedHome, null, null, null);
		FlxMouseEventManager.add(menuItems.members[0], pressedHome, null, null, null);
		FlxMouseEventManager.add(menuItems.members[6], pressedCredits, null, null, null);
		FlxMouseEventManager.add(menuItems.members[8], pressedBadges, null, null, null);
		FlxMouseEventManager.add(menuItems.members[1], pressedFreeplay, null, null, null);
		FlxMouseEventManager.add(menuItems.members[5], pressedDonate, null, null, null);
		FlxMouseEventManager.add(settings, pressedSettings, null, null, null);

		return menuItems;
	}

	public static function generateBG()
	{
		var bg:FlxSprite;
		bg = new FlxSprite().loadGraphic(Paths.image('mainmenu/BG'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		return bg;
	}

	public static function generateHomePage()
	{
		var bgHome:FlxSprite;
		bgHome = new FlxSprite().loadGraphic(Paths.image('mainmenu/Home'));
		bgHome.updateHitbox();
		bgHome.screenCenter();
		bgHome.antialiasing = ClientPrefs.globalAntialiasing;
		return bgHome;
	}

	public static function generateProfilePage()
	{
		var bgProfile:FlxSprite;
		bgProfile = new FlxSprite().loadGraphic(Paths.image('mainmenu/About'));
		bgProfile.updateHitbox();
		bgProfile.screenCenter();
		bgProfile.antialiasing = ClientPrefs.globalAntialiasing;
		return bgProfile;
	}

	public static function generateCredits()
		{
			var bgCredits:FlxSprite;
			bgCredits = new FlxSprite().loadGraphic(Paths.image('mainmenu/Credits'));
			bgCredits.updateHitbox();
			bgCredits.screenCenter();
			bgCredits.antialiasing = ClientPrefs.globalAntialiasing;
			return bgCredits;
		}

	public static function generateIcons()
	{
		var gfIcon:FlxSprite = new FlxSprite(275, 205);
		gfIcon.frames = Paths.getSparrowAtlas("mainmenu/FriendIcons/GirlfriendIcon");
		gfIcon.animation.addByIndices("Status2", "USER3ICON", [2], "", 1, true);
		gfIcon.animation.addByIndices("Status1", "USER3ICON", [1], "", 1, true);
		gfIcon.animation.addByIndices("Status0", "USER3ICON", [0], "", 1, true);
		gfIcon.animation.play("Status" + Std.string(FlxG.random.int(0, 2)), true);

		return gfIcon;
	}
}