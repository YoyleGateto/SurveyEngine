package survey.visuals.options;

import survey.visuals.options.BaseOption;

class StringOption extends BaseOption
{
	public function new(?DisplayName, ?List:Array<String>, ?Save:Dynamic, ?Name:String)
	{
		super(DisplayName, Save, Name);
		list = List ?? ["A", "B", "C"];
		val = list.indexOf(Reflect.field(save, name)) == -1 ? 0 : list.indexOf(Reflect.field(save, name));
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		text.text = list[val];
	}
	
	public function load()
	{
		val = Reflect.field(save, name) ?? min;
	}
	
	public function change(?num:Int = 0)
	{
		val += num;
		if (val >= list.length) val = 0;
		if (val < 0) val = list.length - 1;
		Reflect.setField(save, name, list[val]);
		Utility.playSound("menu/scroll", true);
	}
}