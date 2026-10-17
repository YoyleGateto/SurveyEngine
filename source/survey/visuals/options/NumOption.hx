package survey.visuals.options;

import survey.visuals.options.BaseOption;
class NumOption extends BaseOption
{
	public var min:Float;
	public var max:Float;
	public var step:Float;
	
	override function new(DisplayName:String, Step:Float, Min:Float, Max:Float, Save:Dynamic, Name:String)
	{
		super(DisplayName, Save, Name);
		step = Step;
		min = Min;
		max = Max;
		val = Reflect.field(save, name) ?? min;
	}
	
	override public  function load()
	{
		val = Reflect.field(save, name) ?? min;
	}
	
	override public function change(?num:Int = 0):Int
	{
		val += (step * num);
		if (val > max) val = min;
		if (val < min) val = max;
		Reflect.setField(save, name, val);
		Utility.playSound("menu/scroll", true);
		return num;
	}
}