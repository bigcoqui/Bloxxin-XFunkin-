# Bloxxin'XFunkin' - built on Psych Engine
Psych Engine originally was used on [Mind Games Mod](https://gamebanana.com/mods/301107), intended to be a fix for the vanilla version's many issues while keeping the casual play aspect of it. Also aiming to be an easier alternative to newbie coders.

[Bloxxin'XFunkin'](https://gamebanana.com/mods/292830) has moved to Psych Engine to follow up on the simplistic modding style (maybe).

## Installation:
1. You must have [the most up-to-date version of Haxe](https://haxe.org/download/), seriously, stop using 4.1.5, it misses some stuff.

2. After installing Haxe, [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/).

3. Install `git`.
	 - Windows: install from the [git-scm](https://git-scm.com/downloads) website.
	 - Linux: install the `git` package: `sudo apt install git` (ubuntu), `sudo pacman -S git` (arch), etc... (you probably already have it)

4. Install and set up the necessary libraries:
	 - `haxelib install lime 7.9.0`
	 - `haxelib install openfl`
	 - `haxelib install flixel`
	 - `haxelib install flixel-tools`
	 - `haxelib install flixel-ui`
	 - `haxelib install hscript`
	 - `haxelib install flixel-addons`
	 - `haxelib install actuate`
	 - `haxelib run lime setup`
	 - `haxelib run lime setup flixel`
	 - `haxelib run flixel-tools setup`
	 - `haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit.git`
	 - `haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit`
	 - `haxelib git faxe https://github.com/uhrobots/faxe`
	 - `haxelib git polymod https://github.com/MasterEric/polymod.git`
	 - `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc`
	 - `haxelib git extension-webm https://github.com/KadeDev/extension-webm`
	 - `lime rebuild extension-webm <ie. windows, macos, linux>`
	      - Note: for Linux, you need to install the `g++-multilib` and `gcc-multilib` packages respectively. (use apt to install them.)

__If you don't want your mod to be able to run .lua scripts, delete the "LUA_ALLOWED" line on Project.xml__

## Modders under the Bloxxin'XFunkin' Mod:
* AbraX - Coding, Arts, Animations, Music, Charting, etc.

## Credits to the Psych Engine:
* Shadow Mario - Coding
* RiverOaken - Arts and Animations
* bbpanzu - Assistant Coding

## Contributors of the Psych Engine
* shubs - New Input System
* SqirraRNG - Chart Editor's Sound Waveform base code
* iFlicky - Delay/Combo Menu Song Composer + Dialogue Sounds
* PolybiusProxy - .MP4 Loader Extension
* Keoiki - Note Splash Animations

## Origins of ROBLOX:
* David Baszucki - CEO
* Erik Cassel - CEO
_____________________________________

# Features

## Mod Support
* Probably one of the main points of this engine, you can code in .lua files outside of the source code, making your own weeks without even messing with the source!
* Comes with a Mod Organizing/Disabling Menu. 

## Each song has a different character!:
### Not a Noob:
  * Remastered Noob sprite!
  * New Funky Friday Background!
### Concerning Control:
  * Remastered Guest 666 sprite!
  * New Bloxburg Background!
### Ro Bond:
  * Remastered Bacon sprite!
  * New Livetopia Background!
### Funky Shedsky:
  * NEW Character: Shedletsky!
  * NEW Work at a Pizza Place Background!

## Cool new Chart Editor changes and countless bug fixes
![](https://github.com/ShadowMario/FNF-PsychEngine/blob/main/docs/img/chart.png?raw=true)
* You can now chart "Event" notes, which are bookmarks that trigger specific actions that usually were hardcoded on the vanilla version of the game.
* Your song's BPM can now have decimal values
* You can manually adjust a Note's strum time if you're really going for milisecond precision
* You can change a note's type on the Editor, it comes with two example types:
  * Alt Animation: Forces an alt animation to play, useful for songs like Ugh/Stress
  * Hey: Forces a "Hey" animation instead of the base Sing animation, if Boyfriend hits this note, Girlfriend will do a "Hey!" too.

## Multiple editors to assist you in making your own Mod
![Screenshot_3](https://user-images.githubusercontent.com/44785097/144629914-1fe55999-2f18-4cc1-bc70-afe616d74ae5.png)
* Working both for Source code modding and Downloaded builds!

# Ultimate MENU UI REWORK!

## Home rework:
![Home_Image](https://user-images.githubusercontent.com/68356566/153770139-30b44c02-473d-4ca3-a928-94b7a72a8f30.png)
* There are a good amount of buttons here, but some do not have any functions yet.

## Free Play rework:
![Freeplay_Image](https://user-images.githubusercontent.com/68356566/153769646-0cdce0ec-6212-4ca9-903c-cf0ca466e9c9.png)
* Songs are now formatted to look like games, or in ROBLOX's case, Experiences.

## Credits menu
![Credits_Image](https://user-images.githubusercontent.com/68356566/153769717-402ed2b2-1694-4c05-80bc-21b6134d89eb.png)
* People involved in the creation of said mod or engine now appear in a somewhat grid-like arrangement, hover over an icon to see their contributions!

## Awards/Achievements
![Awards_Image](https://user-images.githubusercontent.com/68356566/153770232-4c34f830-1ac1-4254-95c3-a9e6c9899239.png)
* 3 old badges and 4 new ones for a total of 7 badges to obtain! (Check Achievements.hx and search for "checkForAchievement" on PlayState.hx)

## Options menu:
* You can change Note colors, Delay and Combo Offset, Controls and Preferences there.
 * On Preferences you can toggle Downscroll, Middlescroll, Anti-Aliasing, Framerate, Low Quality, Note Splashes, Flashing Lights, etc.

## Other gameplay features:
* When the enemy hits a note, their strum note also glows.
* Lag doesn't impact the camera movement and player icon scaling anymore.
* Depending on the camera's character focus, Girlfriend will also look at the character!
* Your controls are listed below your set of arrows now!
* New Note Assets!
* Loading Screen simulates how ROBLOX games would load!
![Loading_Image](https://user-images.githubusercontent.com/68356566/153770321-045b97d8-2ea0-4508-bbb6-bef049d5cafa.png)
* Pause Menu simulates the ROBLOX menu in a game!
![Pause_Image](https://user-images.githubusercontent.com/68356566/153770344-9a175336-ee63-413c-bde6-a14a3f46d63e.png)

