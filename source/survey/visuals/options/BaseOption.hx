package survey.visuals.options;

class BaseOption extends FlxSpriteGroup
{
	public var save:Dynamic;
	public var name:String;
	public var displayName:String;
	public var val:Dynamic;
	public var label:FlxText;
	public var text:FlxText;
	public var selected:Bool;
	
	public function new(DisplayName:String, Save:Dynamic, Name:String)
	{
		super(0, 0);
		
		val = 0;
		selected = false;
		
		if (Save != null)
			save = Save;
		
		displayName = DisplayName;
		name = Name;
		
		label = new BitmapText(0,0,"main");
		add(label);
		
		text = new BitmapText(0,0,"main");
		add(text);
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		text.x = x + 320;
		label.text = displayName;
		text.text = val;
	}
}
