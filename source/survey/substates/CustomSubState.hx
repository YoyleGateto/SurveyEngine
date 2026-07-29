package funkin.substates;

import haxe.ds.StringMap;
import scripting.ScriptManager;

class CustomSubState extends SubState
{
    public var scriptName:String = '';    
    public var manager:ScriptManager;
    
    override public function new(script:String, ?args:Array<Dynamic>)
    {
        super();

        scriptName = script;
        manager = new ScriptManager(true, args ?? []);
    }

    override public function create()
    {        
        super.create();

        manager.load("data/substates/" + script);
        manager.loadFolder("data/substates/" + script);

        if (variables != null)
            for (key in variables.keys())
                setOnScripts(key, variables.get(key));

        openCallback = function() {
            manager.callback('open');
            manager.callback('postOpen');
        };

        closeCallback = function() {
            manager.callback('close');
            manager.callback('postClose');
        };

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
        super.destroy();

        manager.callback('destroy');
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
}