package survey.visuals;

import flixel.util.FlxSpriteUtil;

class ModBox extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var text:BitmapText;
	public var mod:Any;
	public function new(?X:Float = 0.0, ?Y:Float = 0.0, ?mod) {
		super(X,Y);
		this.mod = mod;
		var str = mod == null ? "Mod Example" : (mod == 0 ? "New Project" : (mod == 1 ? "Reload" : mod));
		bg = new FlxSprite().makeGraphic(600, 52, 0);
		FlxSpriteUtil.drawRect(bg, 0, 0, bg.width, bg.height, FlxColor.WHITE);
		FlxSpriteUtil.drawRect(bg, 4, 4, bg.width-8, bg.height-8, FlxColor.BLACK);
		add(bg);
		text = new BitmapText(0, 0, "main", str);
		add(text);
	}
	override function update(elapsed:Float) {
		super.update(elapsed);
		text.y = y + (bg.height - text.height) / 2;
		text.x = x + 42;
	}
}