package utils.cool;

import core.enums.PrintType;
import core.Main;

class LogUtil
{
	public static function debugTrace(text:Dynamic, ?type:PrintType = TRACE, ?customType:String = '', ?customColor:FlxColor = FlxColor.GRAY, ?canTrace:Bool = true, ?canPrint:Bool = true, ?pos:haxe.PosInfos)
	{
		if (Vars.data == null || (type.unnecessary() && !Vars.data.verbose))
			return;

		if (canTrace)
			Sys.println(ansiColorString(type == CUSTOM ? customType : type.toString(), type == CUSTOM ? customColor : type.toColor()) + ansiColorString(' | ' + Date.now().toString().split(' ')[1] + ' | ', 0xFF505050) + (pos == null ? '' : ansiColorString(pos.fileName + ':' + pos.lineNumber + ': ', 0xFF888888)) + text);

		if (Vars.data.developerMode && Vars.data.allowDebugPrint && type.printable() && canPrint)
			debugPrint(text, type, customType, customColor);
	}

	public static function debugPrint(text:Dynamic, ?type:PrintType = TRACE, ?customType:String = '', ?customColor:FlxColor = FlxColor.GRAY)
		Main.debugPrintPlugin?.print(text, type == CUSTOM ? customType : type.toString(), type == CUSTOM ? customColor : type.toColor());
	
	public static function showPopUp(title:String, message:String):Void
	{
		debugTrace(title + ' | ' + message, POP_UP);
		FlxG.stage.window.alert(message, title);
	}
}