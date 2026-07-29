package utils.cool;

import sys.FileSystem;
import sys.io.File;

class FileUtil
{
	inline public static function openFolder(folder:String, absolute:Bool = false)
    {
        if (!absolute)
            folder = Sys.getCwd() + '$folder';

        folder = folder.replace('/', '\\');

        if (folder.endsWith('/'))
            folder.substr(0, folder.length - 1);

        #if linux
        var command:String = '/usr/bin/xdg-open';
        #else
        var command:String = 'explorer.exe';
        #end

        Sys.command(command, [folder]);
	}
    
	@:access(flixel.util.FlxSave.validate)
	public static function getSavePath(modSupport:Bool = true):String
		return FlxG.stage.application.meta.get('company') + '/' + flixel.util.FlxSave.validate(FlxG.stage.application.meta.get('file')) + (modSupport ? ((Paths.mod == null ? '' : '/' + (CoolVars.data.modID ?? Paths.mod))) : '');
}