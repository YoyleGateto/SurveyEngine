package scripting;

import ale.rulescript.RuleScriptGlobal;
import haxe.Exception;

using utils.cool.MapUtil;

class ScriptConfig
{
	public static final CLASSES:Array<Class<Dynamic>> = [
        flixel.FlxG,
        flixel.sound.FlxSound,
        flixel.FlxState,
        flixel.FlxSprite,
        flixel.FlxCamera,
        flixel.math.FlxMath,
        flixel.util.FlxTimer,
        flixel.text.FlxText,
        flixel.tweens.FlxEase,
        flixel.tweens.FlxTween,
        flixel.group.FlxSpriteGroup,
        flixel.group.FlxGroup.FlxTypedGroup,

        api.DesktopAPI,
        api.MobileAPI,
        
        sys.FileSystem,
        sys.io.Process,
        sys.io.File,

        haxe.ds.StringMap,
        haxe.ds.IntMap,
        haxe.ds.EnumValueMap,
        
        utils.Utility,
        utils.Vars,
        utils.Keys,
        utils.Json,
        utils.SequenceHandler,
        
        survey.states.CustomState,
        survey.substates.CustomSubState,

        survey.visuals.Camera,
        
        survey.visuals.BitmapText
        survey.objects.DeltaSprite;
		survey.objects.DeltaCharacter;
		survey.objects.DeltaEnemy;

        core.assets.Paths,
	];

    public static final ABSTRACTS:Array<String> = [
        'flixel.util.FlxColor',
        'flixel.util.FlxAxes',
        'flixel.tweens.FlxTween.FlxTweenType'
    ];

    public static final TYPEDEFS:Map<String, Class<Dynamic>> = [
        'Reflect' => rulescript.types.ScriptedReflect
    ];

    public static final VARIABLES:Map<String, Dynamic> = [
        'debugTrace' => debugTrace,
        'initSequence' => SequenceHandler.initSequence,
        'doDialouge' => SequenceHandler.doDialouge,
    ];
    
	public static function config()
	{
        #if HSCRIPT_ALLOWED
        RuleScriptGlobal.reset();

        RuleScriptGlobal.FILE_CHECKER = (id:String) -> Paths.exists(id);
        RuleScriptGlobal.FILE_READER = (id:String) -> Paths.getContent(id);

        RuleScriptGlobal.IMPORTS = RuleScriptGlobal.IMPORTS.concat(CLASSES);
        RuleScriptGlobal.ABSTRACTS = RuleScriptGlobal.ABSTRACTS.concat(ABSTRACTS);
        RuleScriptGlobal.TYPEDEFS = cast RuleScriptGlobal.TYPEDEFS.mapConcat(TYPEDEFS);
        RuleScriptGlobal.VARIABLES = cast RuleScriptGlobal.VARIABLES.mapConcat(VARIABLES);

        RuleScriptGlobal.VARIABLES.set('window', openfl.Lib.application.window);
        RuleScriptGlobal.SCRIPT_PATH = '';
        RuleScriptGlobal.MODULE_PATH = 'source';

        RuleScriptGlobal.ERROR_HANDLER = (error:String) -> debugTrace(error, ERROR);

        RuleScriptGlobal.apply();
		#end
	}
}