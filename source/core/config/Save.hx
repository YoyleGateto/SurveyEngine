package core.config;

import haxe.ds.StringMap;

import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSave;

import utils.cool.FileUtil;

import sys.FileSystem;
import sys.io.File;

class Save
{
    public static var save:FlxSave;
    public static var options(get, never):Dynamic;
    static function get_options():Dynamic
    {
    	return save == null ? {} : save.data;
    }
    
    public static var saveFiles:Array<Dynamic>;
	public static var savesPath:String;
	
	public static var curFile:Dynamic;
	
    public static function init()
    {
    	curFile = { exists: false };
    	
    	saveFiles = [
    		{ exists: false },
		    { exists: false },
		    { exists: false },
		];
    	savesPath = Paths.mod == null ? "saves" : (Paths.mods + "/" + Paths.mod + "/saves");
    	
        save = new FlxSave();
		save.bind('SURVEY_DATA', utils.cool.FileUtil.getSavePath(false));
    }
    
    // SAVE FILES //
    
    public static function loadSaveFiles()
    {
    	saveFiles = [
    		{ exists: false },
		    { exists: false },
		    { exists: false },
		];
		for (id in 0...3) {
			if (FileSystem.exists(savesPath + "/file" + id + ".json")) {
				var save = Json.parse(File.getContent(savesPath + "/file" + id + ".json"));
				save.exists = true;
				saveFiles[id] = save;
			}
		}
	}
	
	public static function overwriteFile(id, save:Dynamic) {
		saveFiles[id] = Json.copy(save);
		flushSaveFiles();
	}
	
	public static function deleteFile(id) {
		if (saveFiles[id].exists) {
			saveFiles[id] = { exists: false };
			if (FileSystem.exists(savesPath + "/file" + id + ".json"))
				FileSystem.deleteFile(savesPath + "/file" + id + ".json");
		}
	}
	
	public static function flushSaveFiles()
    {
		for (id in 0...3) {
			if (saveFiles[id] != null && saveFiles[id].exists) {
				var save = Json.copy(saveFiles[id]);
				File.saveContent(savesPath + "/file" + id + ".json", save);
			}
		}
	}
	
	// CONFIG //
	
    public function loadOptions()
    {
        if (Paths.exists('data/options.json'))
        {
            var jsonData:Dynamic = Paths.json('data/options').options;
            var jsonBinds:Array<Dynamic> = Paths.json('data/options').keybinds;
            
            for (category in jsonData)
            	for (option in category.options)
	                if (option.id != null && Reflect.field(options.data, option.id) == null)
	                    Reflect.setField(options, option.id, option.value);

            for (bind in jsonBinds)
				if (Reflect.field(keybinds.data, bind.id) == null)
                	Reflect.setField(options.keybinds, bind.id, FlxKey.fromString(def));
        }
        
        options.touchPos ??= {};
    }
    
    public static function resetOptions()
    {
        if (Paths.exists('data/options.json'))
        {
            var jsonData:Array<Dynamic> = Paths.json('data/options').options;
            var jsonBinds:Array<Dynamic> = Paths.json('data/options').keybinds;
            
            for (category in jsonData.options)
            	for (option in category.options)
	                Reflect.setField(options, option.id, option.value);

            for (bind in jsonBinds)
				Reflect.setField(options.keybinds, bind.id, FlxKey.fromString(bind.key));
        }
    }
    
    // END //
    
    public static function flush()
    {
        try
        {
        	flushSaveFiles();
        	save.flush();
        } catch(e) {
            debugTrace('While saving: ' + e, ERROR);
        }
    }

    public static function destroy()
    {
        save.destroy();
        save = null;
        
        saveFiles = null;
        curFile = null;
        savesPath = null;
    }
}