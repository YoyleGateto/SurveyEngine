package scripting;

import scripting.HScript;
import ale.rulescript.RuleScriptGlobal;
import rulescript.Context;
import flixel.util.IFlxDestroyable;

@:publicFields
class ScriptManager implements IFlxDestroyable
{
    var members:Array<HScript> = [];
    public final arguments:Array<Dynamic> = [];
    var haxeContext:Context = new Context();
	var subState:Bool = false;

    public function new(subState:Bool, ?args:Array<Dynamic>)
    {
        this.subState = subState;
        arguments = args;
    }

    public function loadFolder(path:String, ?recursive:Bool = true, ?args:Array<Dynamic>)
    {
        if (destroyed)
            return;

        for (file in Paths.readDirectory(path, true))
        {
            final fullPath:String = path + '/' + file;

            if (Paths.isDirectory(fullPath) && recursive)
                loadFolder(fullPath, recursive, args);
            else if (file.endsWith(RuleScriptGlobal.SCRIPT_EXTENSION))
                load(fullPath, args);
        }
    }

    public function load(path:String, ?args:Array<Dynamic>)
    {
        if (destroyed)
            return;

        final fullPath:String = path + RuleScriptGlobal.SCRIPT_EXTENSION;

        if (Paths.exists(fullPath))
        {
            final script:HScript = new HScript(path, haxeContext, args ?? arguments, subState);
            
            if (!script.failedExecution)
            {
                members.push(script);
                debugTrace('"' + fullPath + '" has been loaded', HSCRIPT);
            }
        }
    }

    public function set(name:String, value:Dynamic):Void
    {
        if (destroyed)
            return;

        for (script in members)
            script.set(name, value);
    }

    public function call(name:String, ?args:Array<Dynamic>):Array<Dynamic>
    {
        if (destroyed)
            return [];

        return [for (script in members) script.call(name, args)];
    }
    
    public function callback(name:String, ?args:Array<Dynamic>):Bool
    {
        return call(name, args).contains(false);
    }

    var destroyed(default, null):Bool = false;

    override public function destroy()
    {
        members = null;
        haxeContext = null;

        destroyed = true;
    }
}