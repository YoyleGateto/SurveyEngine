package core.plugins;

import core.enums.KeyCheck;

import flixel.FlxBasic;

import survey.mobile.MobileButton;
import survey.mobile.MobileJoystick;

class MobileControlsPlugin extends FlxTypedGroup<FlxBasic>
{
    override public function new()
    {
        super();
        
        FlxG.signals.preStateCreate.add(clean);
    }
    
    override function destroy()
    {
        super.destroy();
        
        FlxG.signals.preStateCreate.remove(clean);
    }
    
    public var acceptButton:MobileButton;
    public var backButton:MobileButton;
    public var menuButton:MobileButton;
    
    public var joystick:MobileJoystick;
    
    public function checkKey(key:String, prop:KeyCheck):Bool
    {
    	var list:Array<String> = ["up","down","left","right","accept","back","menu"];
	    var useJoystickKey:Array<String>  = ["up","down","left","right"];
		var buttons:StringMap<MobileButton>  = [
			"accept" => acceptButton,
			"back" => backButton,
			"menu" => menuButton
		];
        if (list.contains(key)) {
        	final useStick:Bool = useJoystick.contains(key);
        	if (!useStick) {
	        	final obj:MobileButton = buttons.get(key);
				if (obj != null) {
			        final property:Bool = switch(prop)
		            {
		                case KeyCheck.PRESSED:
		                    obj.pressed;
		                case KeyCheck.JUST_PRESSED:
		                    obj.justPressed;
		                case KeyCheck.JUST_RELEASED:
		                    obj.justReleased;
		            }
		            
		            if (obj.exists && property)
		                return true;
				}
            } else {
				if (joystick != null) {
					final k:Dynamic = joystick.keys.get(key);
			        final property:Bool = switch(prop)
		            {
		                case KeyCheck.PRESSED:
		                    k.pressed;
		                case KeyCheck.JUST_PRESSED:
		                    k.justPressed;
		                case KeyCheck.JUST_RELEASED:
		                    k.justReleased;
		            }
		            
		            if (joystick.exists && property)
		                return true;
				}
            }
        }
        return false;
    }
    
    public function clean(?_)
    {
        destroyControls();
    }

    public function restartControls()
    {
        for (obj in [acceptButton, backButton, menuButton, joystick])
            obj.restart();
    }
    
    public function destroyButtons()
    {
        for (obj in [acceptButton, backButton, menuButton, joystick])
        {
            obj.destroy();
            remove(cast obj, true);
        }
        acceptButton = null;
        backButton = null;
        menuButton = null;
        joystick = null;
    }
    
    public function toggleButtons(show:Bool)
    {
        for (obj in [acceptButton, backButton, menuButton, joystick])
            obj.restart();
            obj.exists = show;
        }
    }
    
    public function createControls()
    {
		acceptButton = new MobileButton(0,0, Paths.sprite("ui/mobile/z"), Paths.sprite("ui/mobile/zPress"));
		acceptButton.updateHitbox();
        add(acceptButton);
        backButton = new MobileButton(0,0, Paths.sprite("ui/mobile/x"), Paths.sprite("ui/mobile/xPress"));
        backButton.updateHitbox();
        add(backButton);
        menuButton = new MobileButton(0,0, Paths.sprite("ui/mobile/c"), Paths.sprite("ui/mobile/cPress"));
		menuButton.updateHitbox();
        add(menuButton);
        joystick = new MobileJoystick(0,0, 720, Paths.sprite("ui/mobile/joystickBase"), Paths.sprite("ui/mobile/joystickThumb"));
        add(joystick);
        for (obj in [acceptButton, backButton, menuButton, joystick])
    		obj.cameras = cameras;
    	updateControls();
    }
    
    public function setAlpha(alpha:Float)
    {
    	for (obj in [acceptButton, backButton, menuButton, joystick])
    		obj.alpha = alpha;
    }
    
    public function updateControls()
    {
    	var positions = [
			joystick: [50, FlxG.height-300],
			accept: [FlxG.width - 200, FlxG.height-130],
			menu: [FlxG.width - 150, FlxG.height-230],
			back: [FlxG.width - 100, FlxG.height-130],
		];
		for (field in Reflect.fields(Save.options.touchPos))
		{
			Reflect.setField(positions, field, Reflect.field(Save.mobileControls.data, field));
		}
	    if(acceptButton != null) {
			acceptButton.x = positions.accept[0];
			acceptButton.y = positions.accept[1];
		}
        if(backButton != null) {
			backButton.x = positions.back[0];
			backButton.y = positions.back[1];
		}
		if(menuButton != null) {
			menuButton.x = positions.menu[0];
			menuButton.y = positions.menu[1];
		}
		if(joystick != null) {
			joystick.x = positions.joystick[0];
			joystick.y = positions.joystick[1];
		}
		setAlpha(Save.options.touchAlpha ?? 0.5);
		for (obj in [acceptButton, backButton, menuButton]) {
			obj.scale.x = obj.scale.y = Save.options.buttonScale ?? 3;
			obj.updateHitbox();
		}
		joystick.scale.x = joystick.scale.y = Save.options.stickScale ?? 4;
    }
}