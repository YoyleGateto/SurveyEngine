package utils;

import api.DesktopAPI;

import core.structures.Metadata;
import core.Main;

import utils.cool.EngineUtil;

import sys.FileSystem;
import sys.io.File;

import openfl.Lib;

class Vars
{
	public static var skipTransIn:Bool = false;
	public static var skipTransOut:Bool = false;

	public static var engineVersion(get, never):String;

	public static function get_engineVersion():String
		return Lib.application?.meta?.get('version') ?? "";

	public static var global:Map<String, Dynamic> = new Map<String, Dynamic>();

	public static final buildTarget:String = #if windows 'windows' #elseif linux 'linux' #elseif mac 'mac' #elseif ios 'ios' #elseif android 'android' #else 'unknown' #end;

	public static final Function_Stop:String = '##_FUNCTION_STOP_##';
	public static final Function_Continue:String = '##_FUNCTION_CONTINUE_##';

	public static var data:Dynamic = null;

	#if mobile
	public static final mobile:Bool = true;
	#else
	public static var mobile(get, never):Bool;
	static function get_mobile():Bool
		return data == null ? false : data.mobileDebug && data.developerMode;
	#end
	
	public static function loadMetadata()
	{
		data = {
			developerMode: false,
			scriptsHotReloading: false,

			verbose: false,
			allowDebugPrint: true,
			
			transition: 'Transition',

			title: 'DeltaFlixel',
			icon: 'icon',
			
			modID: null
		};

		var json:Null<Dynamic> = null;

		for (path in [Paths.mods + '/' + Paths.mod, Paths.assets])
			if (FileSystem.exists(path + '/meta.json'))
				json = cast Json.parse(File.getContent(path + '/meta.json'));

		for (field in Reflect.fields(json))
			if (Reflect.field(data, field) != null)
				Reflect.setField(data, field, Reflect.field(json, field));
		
		FlxG.stage.window.title = Vars.data.title;

		EngineUtil.resizeGame(640, 480);
	}

    public static function reset()
		global.clear();
}