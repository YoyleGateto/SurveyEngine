package utils.cool;

import api.MobileAPI;

class StateUtil
{
	public static function resetState()
	{
		Vars.skipTransOut = true;
		FlxG.resetState();
	}

    public static function switchState(state:flixel.FlxState, skipTransIn:Bool = null, skipTransOut:Bool = null)
    {
        if (state is CustomState)
        {
			var scriptName = cast(state, CustomState).scriptName;
            if (Paths.exists('data/states/' + scriptName + '.hx'))
                transitionSwitch(state, skipTransIn, skipTransOut);
            else
                debugTrace('Custom State called "' + scriptName + '" doesn\'t Exist', MISSING_FILE);
        } else {
			transitionSwitch(state, skipTransIn, skipTransOut);
		}
    }

	private static function transitionSwitch(state:flixel.FlxState, skipTransIn:Bool = null, skipTransOut:Bool = null)
	{
		if (skipTransIn != null)
			Vars.skipTransIn = skipTransIn;

		if (skipTransOut != null)
			Vars.skipTransOut = skipTransOut; 

        if (Vars.skipTransIn)
		{
            Vars.skipTransIn = false;
			FlxG.switchState(state);
		} else {
			openSubState(new CustomSubState(
				Vars.data.transition,
                [true, () -> { FlxG.switchState(state); }],
				null,
			));
		}
	}

	public static function openSubState(subState:flixel.FlxSubState = null)
	{
		if (subState == null)
			return;

        if (subState is CustomSubState)
        {
            var custom:CustomSubState = Std.downcast(subState, CustomSubState);
            if (Paths.exists('data/substates/' + custom.scriptName + '.hx'))
                FlxG.state.openSubState(subState);
            else
                debugTrace('Custom SubState called "' + custom.scriptName + '" doesn\'t Exist', MISSING_FILE);

            return;
        }

		FlxG.state.openSubState(subState);
	}
}