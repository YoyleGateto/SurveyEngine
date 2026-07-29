package survey.visuals.options;

import survey.visuals.options.BaseOption;
import flixel.input.keyboard.FlxKey;

class KeyOption extends BaseOption
{
	public var canInput:Bool = false;

	public function new(?DisplayName, ?List:Array<String>, ?Save:Dynamic, ?Name:String)
	{
		super(DisplayName, Save, Name);
		val = FlxKey.toString(Reflect.field(save, name)) ?? "Z";
		FlxG.stage.addEventListener('keyDown', onKeyDown, false, 1);
	}
	
	override function destroy()
	{
		FlxG.stage.removeEventListener('keyDown', onKeyDown, false);
		super.destroy();
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		text.text = val;
		if (selected)
		{
			if (!canInput) {
				canInput = true;
			}
		} else {
			if (canInput) {
				canInput = false;
			}
		}
	}
	
	function onKeyDown(e:KeyboardEvent)
	{
		if (!canInput)
			return;
		
		final key = e.keyCode;
		
		val = FlxKey.toString(key);
		Reflect.setField(save, name, key);
	
		canInput = false;
		
		Utility.playSound("menu/confirm", true);
	}
	
	public function load()
	{
		val = FlxKey.toString(Reflect.field(save, name)) ?? "Z";
	}
}