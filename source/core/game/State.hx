package core.backend;

import flixel.FlxState;

#if cpp
import cpp.vm.Gc;
#elseif hl
import hl.Gc;
#end

class State extends FlxState
{
    public var cam:Camera;

    public var updating(get, never):Bool;
    function get_updating():Bool
        return subState == null || persistentUpdate || FlxState.transitioning;

    override function create()
    {
        super.create();

		cam = new Camera();
		
		FlxG.cameras.reset(cam);
		FlxG.cameras.setDefaultDrawTarget(cam, true);

        if (Vars.skipTransOut)
        {
            Vars.skipTransOut = false;
        } else {
            #if cpp
            Utility.openSubState(new CustomSubState(
                Vars.data.transition,
                [false, null],
				null,
            ));
            #end
        }
        
        MobileAPI.initControls();
    }

	override function tryUpdate(elapsed:Float):Void
	{
		if (persistentUpdate || (subState == null || FlxState.transitioning))
			update(elapsed);

		if (_requestSubStateReset)
		{
			_requestSubStateReset = false;

			resetSubState();
		}
		
        if (subState != null)
            subState.tryUpdate(elapsed);
	}

	override function destroy()
	{
		MobileAPI.destroyControls();
		
        Paths.clear(shouldClearMemory);

        if (shouldClearMemory)
            cleanMemory();
        
		super.destroy();
	}

    public var shouldClearMemory:Bool = true;

    function cleanMemory()
    {
        #if cpp
        var killZombies:Bool = true;
        
        while (killZombies)
		{
            var zombie = Gc.getNextZombie();
        
            if (zombie == null)
			{
                killZombies = false;
            } else {
                var closeMethod = Reflect.field(zombie, "close");
        
                if (closeMethod != null && Reflect.isFunction(closeMethod))
                    closeMethod.call(zombie, []);
            }
        }
        
        Gc.run(true);
        Gc.compact();
        #end

        #if hl
        Gc.major();
        #end
        
        FlxG.bitmap.clearUnused();
        FlxG.bitmap.clearCache();
    }
}