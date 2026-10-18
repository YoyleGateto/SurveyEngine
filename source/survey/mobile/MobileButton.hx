package survey.mobile;

import flixel.graphics.FlxGraphic;

class MobileButton extends FlxSprite
{
	public var pressed:Bool = false;
	public var justPressed:Bool = false;
	public var justReleased:Bool = false;
	public var idleGraphic:FlxGraphic;
	public var pressGraphic:FlxGraphic;
	
	public function new(?X:Float, ?Y:Float, ?IdleGraphic:FlxGraphic, ?PressGraphic:FlxGraphic)
	{
		super(X ?? 0.0, Y ?? 0.0);
		idleGraphic = IdleGraphic;
		pressGraphic = PressGraphic;
		loadGraphic(idleGraphic);
	}
	
	override function update(elapsed)
	{
		super.update(elapsed);
        
		var isPressing = false;
		for (touch in FlxG.touches.list) {
			var p = touch.getScreenPosition(cameras[0]);
			if (p.x > this.x && p.x < (this.x + this.width) && p.y > this.y && p.y < (this.y + this.height) && touch.pressed)
				isPressing = true;
		}
		
		if (justPressed)
			justPressed = false;
		
		if (justReleased)
			justReleased = false;
		
		if (pressed) {
			if (!isPressing) {
				pressed = false;
				justReleased = true;
			}
			loadGraphic(pressGraphic);
		} else {
			if (isPressing)
				justPressed = pressed = true;
			loadGraphic(idleGraphic);
		}
	}
	
	public function restart()
    {
        pressed = justPressed = justReleased = false;
    }
}
