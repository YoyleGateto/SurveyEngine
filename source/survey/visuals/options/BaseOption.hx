package survey.visuals.options;

class BaseOption extends FlxSpriteGroup
{
	public var save:Dynamic;
	public var name:String;
	public var displayName:String;
	public var val:Null<Dynamic>;
	public var label:FlxText;
	public var text:FlxText;
	public var selected:Bool;
	
	override function new(DisplayName:String, Save:Dynamic, Name:String)
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
	
	public function change(?num:Int = 0):Int
	{
		return num;
	}
	
	public function load()
	{
		val = null;
	}
}
