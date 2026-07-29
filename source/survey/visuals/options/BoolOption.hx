package survey.visuals.options;

import survey.visuals.options.BaseOption;

class BoolOption extends BaseOption
{
	public function new(?DisplayName:String, ?Save:Dynamic, ?Name:String)
	{
		super(DisplayName, Save, Name);
		val = Reflect.field(save, name) ?? false;
	}
	
	public function load()
	{
		val = Reflect.field(save, name) ?? false;
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		text.text = val ? "ON" : ("OFF");
	}
	
	public function change(?num)
	{
		val = !val;
		Reflect.setField(save, name, val);
		Utility.playSound("menu/scroll", 1);
	}
}