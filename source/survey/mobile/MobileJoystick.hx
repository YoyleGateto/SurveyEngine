package survey.mobile;

import flixel.math.FlxPoint;
import flixel.input.touch.FlxTouch;
import flixel.graphics.FlxGraphic;

class MobileJoystick extends FlxSpriteGroup
{
	public var center:FlxPoint = FlxPoint.get(0,0);
	public var thumb:FlxSprite;
	public var base:FlxSprite;
	public var stick:FlxPoint = FlxPoint.get(0,0);
	public var deadzone:Float = 0.5;
	public var radius:Float = 720.0;
	public var button:FlxSprite;
	public var pressed = false;
	public var justPressed = false;
	public var justReleased = false;
	public var disableInput = false;
	var joystickTouch:FlxTouch;
	
	public var keys:StringMap<Dynamic> = new StringMap();
	
	public function new(X:Float = 0.0, Y:Float = 0.0, ?Radius:Float, ?baseGraphic:FlxGraphic, ?thumbGraphic:FlxGraphic)
	{
		super(X, Y);
		for (id in ["left", "up", "right", "down"]) {
			keys.set(id, {
				pressed: false,
				justPressed: false,
				justReleased: false
			});
		}
		base = new FlxSprite();
		if (baseGraphic != null)
			base.loadGraphic(baseGraphic);
		add(base);
		thumb = new FlxSprite();
		if (thumbGraphic != null)
			thumb.loadGraphic(thumbGraphic);
		add(thumb);
		button = new FlxSprite().makeGraphic(1,1,FlxColor.TRANSPARENT);
		add(button);
		radius = Radius ?? 720.0;
	}
	
	public function setPosition(X, Y) {
		this.x = X;
		this.y = Y;
	}
	
	override function update(elapsed)
	{
		thumb.scale.set(scale.x, scale.y);
		thumb.offset.set(thumb.width/2, thumb.height/2);
		
		base.scale.set(scale.x, scale.y);
		base.updateHitbox();
		
		center.x = base.x + (base.width/2);
		center.y = base.y + (base.height/2);
		
		button.scale.set(radius, radius);
		button.updateHitbox();
		button.x = center.x - (radius/1.5);
		button.y = center.y - (radius/2.5);
		
		if (justPressed) justPressed = false;
		if (justReleased) justReleased = false;
		if (pressed && disableInput) pressed = false;
		
		for (id in ["left", "up", "right", "down"]) {
			if (keys.get(id).justPressed) keys.get(id).justPressed = false;
			if (keys.get(id).justReleased) keys.get(id).justReleased = false;
			if (keys.get(id).pressed && disableInput) keys.get(id).pressed = false;
		}
		
		if (!disableInput) {
			if (pressed) {
				pos = joystickTouch.getScreenPosition(cameras[0] ?? FlxG.camera);
				thumb.x = FlxMath.bound(pos.x, base.x, base.x + base.width);
				thumb.y = FlxMath.bound(pos.y, base.y, base.y + base.height);
				stick.x = (thumb.x - center.x) / (base.width * 2);
				stick.y = (thumb.y - center.y) / (base.height * 2);
				if (!(pos.x > button.x && pos.x < (button.x + button.width) && pos.y > button.y && pos.y < (button.y + button.height)) || !joystickTouch.pressed) {
					pressed = false;
					justReleased = true;
				}
			} else {
				thumb.x = center.x;
				thumb.y = center.y;
				stick.x = stick.y = 0;
				for (touch in FlxG.touches.list) {
					pos = touch.getScreenPosition(cameras[0] ?? FlxG.camera);
					if (pos.x > button.x && pos.x < (button.x + button.width) && pos.y > button.y && pos.y < (button.y + button.height) && touch.pressed) {
						joystickTouch = touch;
						pressed = justPressed = true;
					}
				}
			}
			
			if (!keys.get("up").pressed) {
				if (stick.y < -deadzone) {
					keys.get("up").pressed = keys.get("up").justPressed = true;
				}
			} else if (stick.y > -deadzone) {
					keys.get("up").pressed = false;
					keys.get("up").justReleased = true;
				}
			}
			
			if (!keys.get("down").pressed) {
				if (stick.y > deadzone) {
					keys.get("down").pressed = keys.get("down").justPressed = true;
				}
			} else if (stick.y < deadzone) {
					keys.get("down").pressed = false;
					keys.get("down").justReleased = true;
				}
			}
			
			if (!keys.get("left").pressed) {
				if (stick.x < -deadzone) {
					keys.get("left").pressed = keys.get("left").justPressed = true;
				}
			} else if (stick.x > -deadzone) {
					keys.get("left").pressed = false;
					keys.get("left").justReleased = true;
				}
			}
			
			if (!keys.get("right").pressed) {
				if (stick.x > deadzone) {
					keys.get("right").pressed = keys.get("right").justPressed = true;
				}
			} else if (stick.x < deadzone) {
					keys.get("right").pressed = false;
					keys.get("right").justReleased = true;
				}
			}
		} else {
			thumb.x = center.x;
			thumb.y = center.y;
			stick.x = stick.y = 0;
		}
		
		super.update(elapsed);
	}
	
	public function restart()
    {
        pressed = justPressed = justReleased = false;
        stick.set(0, 0);
        for (id in ["left", "up", "right", "down"]) {
			keys.set(id, {
				pressed: false,
				justPressed: false,
				justReleased: false
			});
		}
    }
}