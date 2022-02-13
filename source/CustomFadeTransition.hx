package;

import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.FlxCamera;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transLogo:FlxSprite;
	var transNone:FlxSprite;
	public function new(duration:Float, isTransIn:Bool, wasDisabledTrans:Bool = false) {
		super();

		this.isTransIn = isTransIn;
		FlxG.camera.zoom = 1;

		if (wasDisabledTrans == false)
		{
			transBlack = new FlxSprite(0, 0).loadGraphic(Paths.image("menutransition/imagestate"));
			transBlack.alpha = 1;
			transBlack.scrollFactor.set();
			add(transBlack);

			transLogo = new FlxSprite(1124.4, 588.55);
			transLogo.frames = Paths.getSparrowAtlas("menutransition/spin");
			transLogo.animation.addByPrefix("spin", "robloxspin", 24, false);
			transLogo.scrollFactor.set();
			transLogo.alpha = 1;
			add(transLogo);

			if(isTransIn) 
			{
				FlxTween.tween(transLogo, {alpha: 0}, duration, {ease: FlxEase.linear});
				FlxTween.tween(transBlack, {alpha: 0}, duration, {
					onComplete: function(twn:FlxTween) {
						close();
					},
				ease: FlxEase.linear});
			} 
			else 
			{
				transBlack.color = 0x000000;
				transLogo.color = 0x000000;
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					transLogo.color = 0xFFFFFF;
					transBlack.color = 0xFFFFFF;
					transLogo.animation.play("spin");
				}, 1);
	
				leTween = FlxTween.tween(transBlack, {y: transBlack.y}, duration, {
					onComplete: function(twn:FlxTween) {
						if(finishCallback != null) {
							finishCallback();
						}
					},
				ease: FlxEase.linear});
			}
	
			if(nextCamera != null) {
				transBlack.cameras = [nextCamera];
				transLogo.cameras = [nextCamera];
			}
			nextCamera = null;
		}
		else
		{
			transNone = new FlxSprite(0, 0).makeGraphic(1280, 720, FlxColor.WHITE, true);
			transNone.alpha = 0;
			transNone.scrollFactor.set();
			add(transLogo);

			if(isTransIn) 
			{
				FlxTween.tween(transNone, {alpha: 0}, 0.01, {
					onComplete: function(twn:FlxTween) {
						close();
					},
				ease: FlxEase.linear});
			} 
			else 
			{
				leTween = FlxTween.tween(transNone, {y: transNone.y}, 0.01, {
					onComplete: function(twn:FlxTween) {
						if(finishCallback != null) {
							finishCallback();
						}
					},
				ease: FlxEase.linear});
			}
	
			if(nextCamera != null) {
				transNone.cameras = [nextCamera];
			}
			nextCamera = null;
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function destroy() {
		if(leTween != null) {
			#if MODS_ALLOWED
			if(isTransIn) {
				Paths.destroyLoadedImages();
			}
			#end
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}