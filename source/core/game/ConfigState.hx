package core.game;

import survey.states.ModSelectState;

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
				Utility.switchState(new CustomState("StartupState"), true, true);
			#else
	            if (showedMenu) {
	                Utility.switchState(new CustomState("StartupState"), true, true);
	            } else {
	                showedMenu = true;
	                Utility.switchState(new ModSelectState(), true, false);
	            }
            #end
        });
    }
}