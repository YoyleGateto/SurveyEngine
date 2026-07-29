import flixel.FlxState;

var transBlack:FlxSprite;

function new(transIn:Bool, ?call:Void -> Void)
{
	FlxState.transitioning = true;
	
	subCamera.flashSprite.scaleX = subCamera.flashSprite.scaleY = 4;
	
	transBlack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	transBlack.scrollFactor.set();
	add(transBlack);
	transBlack.cameras = [subCamera];
	if (transIn) {
		transBlack.alpha = 0;
		FlxTween.tween(transBlack, {alpha: 1}, 0.32, {onComplete: () -> {
			call();
		}});
	} else {
		FlxTween.tween(transBlack, {alpha: 0}, 0.32, {onComplete: () -> {
			close();
		}});
	}
}

function onDestroy()
{
	FlxState.transitioning = false;
}