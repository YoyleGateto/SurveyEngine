package core.config;

import survey.states.ModsState;

import flixel.FlxState;
import api.DesktopAPI;
import core.Main;
import sys.FileSystem;

class ConfigState extends FlxState
{
    @:unreflective static var showedMenu:Bool = #if mobile false #else true #end;

    override public function create()
    {
        super.create();

        Main.postResetConfig();
        
		FlxTimer.wait(0.0001, () -> {
			#if !includesModding
				CoolUtil.switchState(new CustomState("StartupState"), true, true);
			#else
	            if (showedMenu) {
	                CoolUtil.switchState(new CustomState("StartupState"), true, true);
	            } else {
	                showedMenu = true;
	                CoolUtil.switchState(new ModsState(), true, false);
	            }
            #end
        });
    }
}