package scripting;

import ale.rulescript.RuleScript;
import rulescript.Context;

class HScript extends RuleScript
{
	public final subState:Bool;

	override public function new(scriptName:String, context:Context, ?args:Array<Dynamic>, subState:Bool)
	{
		this.subState = subState;

		super(scriptName, subState ? FlxG.state : FlxG.state.subState, context);
		set('game', superInstance);
		
		run();
		call('new', args);
	}
}