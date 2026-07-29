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
        manager = new ScriptManager(true, args ?? []);
    }

    @:unreflective var watchFiles:Array<String> = [];

    override public function create()
    {        
        super.create();

        manager.load("data/substates/" + script);
        manager.loadFolder("data/substates/" + script);
        
        #if cpp
        FlxG.autoPause = !CoolVars.data.developerMode || !CoolVars.data.scriptsHotReloading;
        #end

        manager.callback('create');
        manager.callback('postCreate');
    }

    override public function update(elapsed:Float)
    {
        if (manager.callback('update', [elapsed]))
        {
            super.update(elapsed);
        }

        manager.callback('postUpdate', [elapsed]);
    }

    override public function destroy()
    {
        manager.callback('destroy');
        super.destroy();
        
        FlxG.autoPause = true;
        
        manager.callback('postDestroy');
        manager.destroy();
    }

    override public function onFocus()
    {
        if (manager.callback('onFocus'))
            super.onFocus();

        manager.callback('postFocus');
    }

    override public function onFocusLost()
    {
        if (manager.callback('onFocusLost'))
            super.onFocusLost();

        manager.callback('postFocusLost');
    }

    override public function openSubState(substate:flixel.FlxSubState):Void
    {
        if (manager.callback('openSubState', [substate]))
            super.openSubState(substate);

        manager.callback('postOpenSubState', [substate]);
    }

    override public function closeSubState():Void
    {
        if (manager.callback('closeSubState'))
            super.closeSubState();

        manager.callback('postCloseSubState');
    }

    public function resetCustomState()
    {
        shouldClearMemory = false;
        CoolUtil.switchState(new CustomState(scriptName, manager.arguments), true, true);
        debugTrace('Current State: ' + scriptName, RESET_STATE);
    }
}