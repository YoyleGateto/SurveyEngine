package utils;

class SequenceHandler {
	public static var text:FlxText;
	public static var portrait:FlxSprite;
	public static var box:FlxSprite;
	
	public static var timer:FlxTimer;
	public static var sequence:Array<Void -> Void> = [];
	public static var conditionCallback:Null<Void -> Bool>;
    public static var _keepText:Bool = false;
    
    public static function clean(?state:flixel.FlxState)
    {
    	if (timer != null)
			timer.cancel();
		text = null;
		portrait = null;
		box = null;
    	sequence = [];
 	   conditionCallback = null;
	}
	
	public static function callEvent()
	{
		if (sequence.length > 0) {
			var ev = sequence.shift();
			ev();
		}
	}
	
	public static function doDialouge(?str:String = "", ?keepText:Bool, ?cantContinue:Bool, ?soundPath:OneOfTwo<String, Array<String>>, ?graphicPath:Null<String>, ?offset:Float){
		conditionCallback = null;
		
		_keepText = keepText;
		
		if (timer != null)
			timer.cancel();
		
		if (graphicPath != null && portrait != null) {
			portrait.loadGraphic(Paths.sprite("ui/textbox/face/" + graphicPath));
			portrait.scale.set(2, 2);
			portrait.updateHitbox();
			portrait.visible = true;
		} else {
			if (portrait != null)
				portrait.visible = false;
		}
		
		if (text != null)
			text.visible = true;
			
		if (box != null)
			box.visible = true;
		
		var sounds = [];
		if (soundPath == null)
		{
			sounds = [Paths.sound("text/default")];
		} else {
			if (soundPath[0] != null)
				sounds = [for (sound in soundPath) Paths.sound("text/" + sound ?? "default")];
			else
				sounds = [Paths.sound("text/" + soundPath)];
		}
		
		if (!keepText && text != null)
			text.text = "";
		
		var chars = str.split("");
		var lastChar = "";
		if (!cantContinue) {
			conditionCallback = () -> {
				if(Keys.BACK_P) {
					timer.cancel();
					text.text = str.replace("|w", "");
					conditionCallback = () -> {
						if(Keys.ACCEPT_P) {
							endDialouge();
							return true;
						}
						return false;
					}
				}
				if(Keys.MENU) {
					if (timer != null) {
						timer.cancel();
					}
					endDialouge();
					return true;
				}
				return false;
			}
		} else {
			conditionCallback = () -> {
				if(Keys.BACK_P || Keys.MENU) {
					if (timer != null) {
						timer.cancel();
					}
					text.text = str.replace("|w", "");
					return true;
				}
				return false;
			}
		}
		
		timer.start(offset ?? 0.02, (ses) -> {
			final nextChar = chars.shift();
			if (text != null) {
				if (nextChar != "\\") {
					if (nextChar == "n" && lastChar == "\\") { 
						text.text += "\n";
						lastChar = nextChar;
						return;
					}
				} else {
					lastChar = nextChar;
					return;
				}
				if (nextChar != "|") {
					if (nextChar == "w" && lastChar == "|") { 
						lastChar = nextChar;
						return;
					}
				} else {
					lastChar = nextChar;
					return;
				}
				text.text += nextChar;
			}
			
			var sound = FlxG.sound.load(sounds[FlxG.random.int(0, sounds.length - 1)]);
			if (sound != null)
				sound.play(true);
			
			lastChar = nextChar;
			if (chars.length == 0) {
				if (timer != null)
					timer.cancel();
					
				if (!cantContinue) {
					conditionCallback = () -> {
						if(Keys.ACCEPT_P) {
							endDialouge();
							return true;
						}
						return false;
					}
				} else {
					callEvent();
				}
			}
		}, chars.length * 10);
	}
	
	public static function enableContinue()
	{
		conditionCallback = () ->  {
			if(Keys.ACCEPT_P) {
				endDialouge();
				return true;
			}
			return false;
		}
	}
	
	public static function endDialouge()
	{
		if (text != null && !_keepText) text.text = "";
		if (portrait != null) portrait.visible = false;
		if (text != null) text.visible = false;
		if (box != null) box.visible = false;
	}
	
	public static function update()
	{
		if (conditionCallback != null) {
			var result = conditionCallback();
			if (result) {
				conditionCallback = null;
				callEvent();
			}
		}
	}
	
	public static function initSequence(sequenceEvents:Array<Void -> Void>)
	{
		sequence = sequenceEvents;
		callEvent();
	}
	
	public static function init()
    {
        timer = new FlxTimer();
        
        FlxG.signals.preStateCreate.add(clean);
        FlxG.signals.postUpdate.add(update);
    }
    
    public static function destroy()
    {
    	FlxG.signals.preStateCreate.remove(clean);
        FlxG.signals.postUpdate.remove(update);
    	clean();
    }
}