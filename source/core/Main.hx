package core;

import haxe.io.Path;
import haxe.Http;

import lime.app.Application;

import openfl.display.Sprite;
import openfl.ui.Mouse;
import openfl.Lib;

#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
#end

import flixel.input.keyboard.FlxKey;

import survey.debug.DebugCounter;

import core.config.MainState;
import core.backend.SoundTray;
import core.plugins.*;
import core.Program;

import scripting.ScriptConfig;

import lime.graphics.Image;

#if android
import extension.androidtools.os.Environment as AndroidEnvironment;
import extension.androidtools.Permissions as AndroidPermissions;
import extension.androidtools.os.Build.VERSION as AndroidVersion;
import extension.androidtools.Settings as AndroidSettings;
import extension.androidtools.os.Build.VERSION_CODES as AndroidVersionCode;
#end

#if mobile
import openfl.Assets as OpenFLAssets;
import openfl.utils.ByteArray;

import sys.FileSystem;
import sys.io.File;

import haxe.Exception;
#end

import api.DesktopAPI;
import api.MobileAPI;

import core.plugins.MobileControlsPlugin;

#if WINDOWS_API
@:buildXml('
<target id="haxe">
	<lib name="wininet.lib" if="windows" />
	<lib name="dwmapi.lib" if="windows" />
</target>
')

@:cppFileCode('
#include <windows.h>
#include <winuser.h>
#pragma comment(lib, "Shell32.lib")
extern "C" HRESULT WINAPI SetCurrentProcessExplicitAppUserModelID(PCWSTR AppID);
')
#end

#if linux
@:cppInclude('./config/gamemode_client.h')
@:cppFileCode('
	#define GAMEMODE_AUTO
')
#end

class Main extends Sprite
{
	@:allow(utils.Vars)
	
	@:unreflective public function new()
	{
		super();

		#if android
		if (AndroidVersion.SDK_INT >= AndroidVersionCode.M)
		{
			if (!AndroidEnvironment.isExternalStorageManager())
			{
				AndroidSettings.requestSetting('MANAGE_APP_ALL_FILES_ACCESS_PERMISSION');
				Utility.showPopUp('...', 'ONCE YOU GIVED THE CONSENT, THE PROGRAM WILL CLOSE, REOPEN IT AND YOU SHALL BEGIN.');
				Sys.exit(0);
				return;
			}
		}
		#end

		preConfig();		
		addChild(new Program(ConfigState));
		postConfig();
	}

	@:unreflective function preConfig()
	{
		DesktopAPI.reset();
		
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, 
			(e) -> {
				var errMsg:String = '';

				final callStack:Array<StackItem> = CallStack.exceptionStack(true);

				for (stackItem in callStack)
				{
					switch (stackItem)
					{
						case FilePos(s, file, line, column):
							errMsg += file + " (line " + line + ")\n";
						default:
							Sys.println(stackItem);
					}
				}

				errMsg += "\nUNCAUGHT ERROR: " + e.error;
				
				#if allowWindowsAPI
					DesktopAPI.showMessageBox(errMsg, "CRASH", ERROR);
				#else
					#if mobile
						Utility.showPopup("CRASH", errMsg);
					#else
						Application.current.window.alert(errMsg, "CRASH");
					#end
				#end

				Sys.println(errMsg);
				DesktopAPI.reset();
				Sys.exit(1);
			}
		);
		
		Lib.application.window.onClose.add(DesktopAPI.reset);

		#if android
			final androidPath:String = AndroidEnvironment.getExternalStorageDirectory() + '/.' + Lib.application?.meta?.get('file');	
			if (!FileSystem.exists(androidPath))
				FileSystem.createDirectory(androidPath);
	
			Sys.setCwd(Path.addTrailingSlash(androidPath));
		#end
	}

	@:unreflective function postConfig()
	{
		#if allowWindowsAPI
			untyped __cpp__("SetProcessDPIAware();");
	
			FlxG.stage.window.borderless = true;
			FlxG.stage.window.borderless = false;
	
			Application.current.window.x = Std.int((Application.current.window.display.bounds.width - Application.current.window.width) / 2);
			Application.current.window.y = Std.int((Application.current.window.display.bounds.height - Application.current.window.height) / 2);
		#end

		#if desktop
			var origin:String = #if hl Sys.getCwd() #else Sys.programPath() #end;
	
			var configPath:String = Path.directory(Path.withoutExtension(origin));
	
			#if mac
				configPath = Path.directory(configPath) + "/Resources/plugins/alsoft.conf";
			#else
				configPath += "/plugins/alsoft.conf";
			#end

			Sys.putEnv("ALSOFT_CONF", configPath);
		#end

		#if allowVideos
			hxvlc.util.Handle.init(#if (hxvlc >= "1.8.0") ['--no-lua'] #end);
		#end

		FlxG.stage.addEventListener('keyDown', (event) -> {
			if (event.altKey && event.keyCode == FlxKey.ENTER)
				event.stopImmediatePropagation();
		}, false, 1);

		function resetSpriteCache(sprite:Sprite)
		{
			@:privateAccess {
		        sprite.__cacheBitmap = null;
				sprite.__cacheBitmapData = null;
			}
		}
		
		FlxG.signals.gameResized.add((w, h) -> {
		     if (FlxG.cameras != null)
				for (cam in FlxG.cameras.list)
					if (cam != null && cam.filters != null)
						resetSpriteCache(cam.flashSprite);

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});
	}

	public static var debugCounter:DebugCounter;
	
	public static var debugPrintPlugin:DebugPrintPlugin;
	public static var mobileControlsPlugin:MobileControlsPlugin;

    @:unreflective public static function preResetConfig()
    {
		DesktopAPI.reset();

		#if desktop
			Mouse.cursor = ARROW;
		#end

		if (FlxG.state.subState != null)
			FlxG.state.subState.close();
		
		FlxTween.globalManager.clear();

		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music = null;
		}
		
		PluginsHandler.destroy();
		SequenceHandler.destroy();
		debugPrintPlugin = null;
		Vars.reset();
		debugCounter?.destroy();

		FlxG.stage.removeChild(debugCounter);
    }

	@:unreflective static var allowMobileConfig:Bool = true;

    @:unreflective public static function postResetConfig()
    {
		if (allowMobileConfig)
		{
			#if mobile
			final textExtensions:Array<String> = ['ini', 'txt', 'xml', 'hx', 'lua', 'json', 'frag', 'vert'];

			final localFiles:Array<String> = OpenFLAssets.list().filter(file -> !FileSystem.exists(file));

			for (file in localFiles)
			{
				final directory:String = Path.directory(file);

				try
				{
					if (OpenFLAssets.exists(file))
					{
						if (!FileSystem.exists(directory))
							FileSystem.createDirectory(directory);

						if (textExtensions.contains(Path.extension(file)))
							File.saveContent(file, OpenFLAssets.getText(file));
						else
							File.saveBytes(file, ['otf', 'ttf'].contains(Path.extension(file)) ? ByteArray.fromFile(file) : OpenFLAssets.getBytes(file));
					} else {
						debugTrace(file, MISSING_FILE);
					}
				} catch (e:Exception) {}
			}
			#end

			allowMobileConfig = false;
		}

		Save.destroy();

        FlxSprite.defaultAntialiasing = false;
		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 30;
		FlxG.keys.preventDefaultKeys = [TAB];

		#if android
			FlxG.android.preventDefaultKeys = [BACK];
		#end

		FlxG.mouse.visible = true;
		FlxG.mouse.unload();
		FlxG.mouse.useSystemCursor = true;

		Paths.clear(true, true);
		Paths.initMod();
        Vars.loadMetadata();
        Paths.init();
		Discord.init();
        Save.init();
		ScriptConfig.config();
		PluginsHandler.init();
		SequenceHandler.init();
		
		Lib.current.stage.window.setIcon(Paths.library.getImage(CoolVars.data.icon + '.png'));

		final soundTray:SoundTray = cast FlxG.game.soundTray;
		if (soundTray != null)
		{
			soundTray.font = Paths.font('main.ttf');
			soundTray.sound = Paths.sound('menu/scroll');
		}

		FlxG.stage.addChild(debugCounter = new DebugCounter());
		
		if (Vars.data.allowDebugPrint && CoolVars.data.developerMode)
			PluginsHandler.add(debugPrintPlugin = new DebugPrintPlugin());
			
		if (Vars.mobile)
			PluginsHandler.add(mobileControlsPlugin = new MobileControlsPlugin());
    }
}
