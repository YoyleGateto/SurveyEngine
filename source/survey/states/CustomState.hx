package survey.states;

import haxe.ds.StringMap;
import scripting.ScriptManager;

class CustomState extends State
{
    public var scriptName:String = '';
	public var manager:ScriptManager;
    
    override public function new(script:String, ?args:Array<Dynamic>)
    {
        super();

        scriptName = script;
        manager = new ScriptManager(false, args ?? []);
    }

    @:unreflective var watchFiles:Array<String> = [];

    override function create()
    {        
        super.create();

        manager.load("data/states/" + scriptName);
        manager.loadFolder("data/states/" + scriptName);
        
        #if cpp
        FlxG.autoPause = !Vars.data.developerMode || !Vars.data.scriptsHotReloading;
        #end

        manager.callback('create');
        manager.callback('postCreate');
    }

    override function update(elapsed:Float)
    {
        if (manager.callback('update', [elapsed]))
        {
            super.update(elapsed);
        }

        manager.callback('postUpdate', [elapsed]);
    }

    override function destroy()
    {
        manager.callback('destroy');
        super.destroy();
        
        FlxG.autoPause = true;
        
        manager.callback('postDestroy');
        manager.destroy();
    }

    override function onFocus()
    {
        if (manager.callback('onFocus'))
            super.onFocus();

        manager.callback('postFocus');
    }

    override function onFocusLost()
    {
        if (manager.callback('onFocusLost'))
            super.onFocusLost();

        manager.callback('postFocusLost');
    }

    override function openSubState(substate:flixel.FlxSubState):Void
    {
        if (manager.callback('openSubState', [substate]))
            super.openSubState(substate);

        manager.callback('postOpenSubState', [substate]);
    }

    override function closeSubState():Void
    {
        if (manager.callback('closeSubState'))
            super.closeSubState();

        manager.callback('postCloseSubState');
    }

    public function reset()
    {
        shouldClearMemory = false;
        Utility.switchState(new CustomState(scriptName, manager.arguments), true, true);
        debugTrace('Current State: ' + scriptName, RESET_STATE);
    }
}