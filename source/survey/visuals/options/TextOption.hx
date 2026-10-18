package survey.visuals.options;

import survey.visuals.options.BaseOption;

class TextOption extends BaseOption
{
	public function new(DisplayName:String, Callback:Void -> Void)
	{
		super(DisplayName, {}, "");
		text.visible = false;
		if (Callback != null)
			callback = Callback;
	}
}