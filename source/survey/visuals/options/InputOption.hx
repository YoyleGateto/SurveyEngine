package survey.visuals.options;

import flixel.input.keyboard.FlxKey;
import lime.system.Clipboard;
import openfl.events.KeyboardEvent;
import flixel.math.FlxRect;
import survey.visuals.options.BaseOption;

using StringTools;

class InputOption extends BaseOption
{
	public var line:FlxSprite;
	public var canInput:Bool = false;
	
	public function new(DisplayName:String, Save:Dynamic, Name:String)
	{
		super(DisplayName, Save, Name);
		
		val = Reflect.field(save, name) ?? "";

		line = new FlxSprite().makeGraphic(240, 2, FlxColor.WHITE);
		add(line);
		
		FlxG.stage.addEventListener('keyDown', onKeyDown, false, 1);
		FlxG.stage.window.onTextInput.add(onTextInput);
	}
	
	public function load()
	{
		val = Reflect.field(save, name) ?? "";
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (selected)
		{
			if (!canInput) {
				canInput = true;
				FlxG.stage.window.textInputEnabled = true;
			}
		} else {
			if (canInput) {
				canInput = false;
				FlxG.stage.window.textInputEnabled = false;
			}
		}
		
		if (canInput && CoolVars.mobile && !FlxG.stage.window.textInputEnabled)
			FlxG.stage.window.textInputEnabled = true;
		
		line.x = label.x + 320;
		line.y = text.y + 32;
		
		var offset = Math.max(text.width - line.width, 0);
		text.x = line.x - offset;
		text.clipRect = FlxRect.get(offset, 0, line.width, text.height);
	}

	override function destroy()
	{
		FlxG.stage.removeEventListener('keyDown', onKeyDown, false);
		FlxG.stage.window.onTextInput.remove(onTextInput);
		canInput = false;
		FlxG.stage.window.textInputEnabled = false;
		
		super.destroy();
	}

	function onKeyDown(e:KeyboardEvent)
	{
		if (!canInput)
			return;
		
		final key = e.keyCode;
	
		var toAdd = null;
	
		switch (key)
		{
			case FlxKey.SHIFT, FlxKey.CONTROL, FlxKey.BACKSLASH, FlxKey.ALT:
	
			case FlxKey.ENTER, FlxKey.ESCAPE:
				canInput = false;
				FlxG.stage.window.textInputEnabled = false;
			
			case FlxKey.BACKSPACE:
				if (val != "") {
					val = val.substring(0, val.length-1);
					Utility.playSound("menu/scroll", 1);
				}
				
			case FlxKey.SPACE:
				toAdd = ' ';
				
			default:
				if (e.ctrlKey && key == FlxKey.C)
					Clipboard.text = val;
				if (e.ctrlKey && key == FlxKey.V)
					onTextInput(Clipboard.text);
		}
		
		Reflect.setField(save, name, val);
	}

	function onTextInput(toAdd:String)
	{
		if (!canInput)
			return;

		val = val + toAdd;
		Reflect.setField(save, name, val);
		
		Utility.playSound("menu/scroll", 1);
	}
	
	public function change(?num) {}
}