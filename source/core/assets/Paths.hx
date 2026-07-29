package core.assets;

import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.Assets;
import haxe.io.Path;

import haxe.Constraints.Function;
import haxe.ds.StringMap;

import core.assets.AssetLibrary;

import core.structures.CacheConfig;

import core.enums.FileType;

import openfl.utils.Assets as OpenFLAssets;
import openfl.display3D.textures.RectangleTexture;
import openfl.display.BitmapData;
import openfl.media.Sound;

import lime.media.AudioBuffer;
import lime.utils.Bytes;
import lime.system.CFFI;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxSave;

import sys.FileSystem;
import sys.FileStat;
import sys.io.File;

class Paths
{
    @:unreflective public static var disableMods:Bool = false;

    @:unreflective static var usedCommandMod:Bool = false;

    public static final assets:String = 'assets';
    public static final mods:String = 'mods';
    public static var mod:Null<String> = null;
    public static var cacheOnGPU:Bool = true;

    @:unreflective public static function initMod()
    {
        disableMods = false;
        #if !includesModding
        	disableMods = true;
        #end
		mod = null;

        final modCheckSteps:Array<Void -> Void> = [
            () -> {
                if (Sys.args()[0] != null && !usedCommandMod)
                {
                    mod = Sys.args()[0].trim();

                    usedCommandMod = true;
                }
            },
            () -> {
                final save:FlxSave = new FlxSave();
                
                save.bind('SURVEY_DATA', utils.cool.FileUtil.getSavePath(false));

                if (save != null)
                    mod = save.data.currentMod;
            }
        ];
        
		if (!disableMods) {
	        var curStep:Int = 0;
	
	        while (mod == null && curStep < modCheckSteps.length)
	        {
	            modCheckSteps[curStep]();
	                
	            if (!FileSystem.exists(mods + '/' + mod))
	                mod = null;
	
	            curStep++;
	        }
		}
    }
    
    public static final SEPARATOR:String = '::';

    public static var library(get, never):AssetLibrary;
    static function get_library():AssetLibrary
        return cast OpenFLAssets.getLibrary('default');

    public static var config:StringMap<CacheConfig> = new StringMap();

    public static function init()
    {
        OpenFLAssets.registerLibrary('default', new AssetLibrary([for (root in [mod == null ? null : mods + '/' + mod, assets, ""]) if (root != null) root]));

        config = [
            FileType.CONTENT => {
                method: (id, permanent, missingPrint) -> {
                    return OpenFLAssets.getText(id);
                }
            },
            FileType.BYTES => {
                method: (id, permanent, missingPrint) -> {
                    return OpenFLAssets.getBytes(id);
                }
            },
            FileType.SPRITE => {
                prefix: 'sprites/',
                postfix: '.png',
                method: (id, permanent, missingPrint) -> {
                    final bitmap:BitmapData = BitmapData.fromImage(library.getImage(id));
                    
                    if (cacheOnGPU)
                    {
                        final texture:RectangleTexture = FlxG.stage.context3D.createRectangleTexture(bitmap.width, bitmap.height, BGRA, true);

                        texture.uploadFromBitmapData(bitmap);
                    }
                    
                    final graphic:FlxGraphic = FlxGraphic.fromBitmapData(bitmap, false, id);
                    graphic.persist = true;
                    graphic.destroyOnNoUse = false;
                    
                    return graphic;
                }
            },
            FileType.AUDIO => {
                postfix: '.ogg',
                method: (id, permanent, missingPrint) -> {
                    return Sound.fromAudioBuffer(AudioBuffer.fromBytes(OpenFLAssets.getBytes(id)));
                }
            },
            FileType.ATLAS => {
                method: (id, permanent, missingPrint) -> {
                    final graphic:FlxGraphic = image(id, permanent, missingPrint);
                    final data:String = getContent('images/' + id + '.xml', permanent, missingPrint);
                    
                    return FlxAtlasFrames.fromSparrow(graphic, data);
                },
                verifyExistence: false
            },
            FileType.MULTI_ATLAS => {
                method: (id, permanent, missingPrint) -> {
                    final files:Array<String> = id.split(SEPARATOR);
                    
                    var parentFrames:FlxAtlasFrames = getAtlas(files[0], permanent, missingPrint);

                    if (files.length > 1)
                    {
                        var original:FlxAtlasFrames = parentFrames;

                        parentFrames = new FlxAtlasFrames(parentFrames.parent);
                        parentFrames.addAtlas(original, true);

                        for (i in 1...files.length)
                        {
                            var extraFrames:FlxAtlasFrames = getAtlasAtlas(files[i], permanent, missingPrint);

                            if (extraFrames != null)
                                parentFrames.addAtlas(extraFrames, true);
                        }
                    }

                    return parentFrames;
                },
                verifyExistence: false
            },
            FileType.JSON => {
                postfix: '.json',
                method: (id, permanent, missingPrint) -> {
                    final content:String = getContent(id, permanent, missingPrint);

                    if (content == null)
                        return null;

                    return Json.parse(content);
                },
                forceCleaning: true
            }
        ];
    }

    public static function clear(cleanAll:Bool, ?perm:Bool = false)
    {
        for (obj in config)
            if ((cleanAll || obj.forceCleaning) && obj.cache != null)
                for (cacheID in obj.cache.keys())
                {
                    final res:Dynamic = obj.cache.get(cacheID);

                    if (!res.permanent || perm)
                    {
                        if (res is IFlxDestroyable)
                            FlxDestroyUtil.destroy(res);

                        obj.cache.remove(cacheID);
                    }
                }

        if (perm)
        {
            @:privateAccess
            for (key in FlxG.bitmap._cache.keys())
            {
                final obj = FlxG.bitmap._cache.get(key);

                if (obj != null && !config.get(FileType.SPRITE).cache.exists(key))
                {
                    FlxG.bitmap._cache.remove(key);

                    obj.destroy();
                }
            }
        }
    }

    // Utils

    public static function get(file:String, configID:String, permanent:Bool, missingPrint:Bool, ?cache:Bool = true):Dynamic
    {
        final data:CacheConfig = config.get(configID);

        if (data == null)
            return null;

        final path:String = data.prefix + file + data.postfix;

        if (data.cache.exists(path))
            return data.cache.get(path).content;

        if (!exists(path) && data.verifyExistence)
        {
            if (missingPrint)
                debugTrace(path, MISSING_FILE);

            return null;
        }

        final result:Dynamic = data.method(path, permanent, missingPrint);

        if (result == null)
            return null;

        if (cache)
            data.cache.set(path, {content: result, permanent: permanent});

        return result;
    }

    public static function getPath(file:String, ?missingPrint:Bool = true):String
    {
        final path:String = library.getPath(file);

        if (path == null && missingPrint)
            debugTrace(file, MISSING_FILE);

        return path;
    }

    // File System

    public static function exists(path:String):Bool
        return OpenFLAssets.exists(path);

    public static function isDirectory(path:String):Bool
    {
        if (exists(path))
            if (FileSystem.isDirectory(getPath(path)))
                return true;

        return false;
    }

    public static function readDirectory(path:String, ?multiple:Bool = false, ?missingPrint:Bool = true):Array<String>
    {
        var result:Array<String> = [];

        for (folder in library.roots)
        {
            var finalPath:String = folder + '/' + path;

            if (FileSystem.exists(finalPath))
            {
                if (FileSystem.isDirectory(finalPath))
                {
                    result = result.concat(FileSystem.readDirectory(finalPath));

                    if (!multiple)
                        break;
                }
            }
        }
        
        result.sort((a, b) -> return Reflect.compare(a, b));

        return result;
    }

    public static function stat(path:String, ?missingPrint:Bool = true):FileStat
    {
        if (exists(path))
            return FileSystem.stat(getPath(path));

        if (missingPrint)
            debugTrace(path, MISSING_FILE);

        return null;
    }

    // Files

    public static function getBytes(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):String
        return get(file, FileType.BYTES, permanent, missingPrint, false);

    public static function getContent(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):String
        return get(file, FileType.CONTENT, permanent, missingPrint, false);
    
    public static function saveContent(file:String, content:String)
        File.saveContent((Paths.mod == null ? assets : (mods + "/" mod)) + "/" + file, content);
    
    public static function saveBytes(file:String, bytes:Bytes)
        File.saveBytes((Paths.mod == null ? assets : (mods + "/" mod)) + "/" + file, bytes);

    // Sprites

    public static function sprite(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):FlxGraphic
        return get(file, FileType.SPRITE, permanent, missingPrint);

    public static function getAtlas(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):FlxAtlasFrames
        return get(file, FileType.ATLAS, permanent, missingPrint);

    public static function getMultiAtlas(files:Array<String>, ?permanent:Bool = false, ?missingPrint:Bool = true):FlxAtlasFrames
        return get(files.join(SEPARATOR), FileType.MULTI_ATLAS, permanent, missingPrint);
    
    // Audio

    public static function audio(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):Sound
        return get(file, FileType.AUDIO, permanent, missingPrint);

    public static function music(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):Sound
        return audio('music/' + file, permanent, missingPrint);

    public static function sound(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):Sound
        return audio('sounds/' + file, permanent, missingPrint);

    // Data

    public static function json(file:String, ?permanent:Bool = false, ?missingPrint:Bool = true):Dynamic
        return Json.copy(get(file, FileType.JSON, permanent, missingPrint));

    public static function ndll(fileName:String, funcName:String, ?args:Int = 0, ?missingPrint:Bool = true):Dynamic
    {
        final path:String = getPath('ndlls/' + fileName + '-' + CoolVars.BUILD_TARGET + '.ndll', missingPrint);

        return path == null ? Reflect.makeVarArgs((arr:Array<Dynamic>) -> {}) : CFFI.load(path, funcName, args ?? 0);
    }

    // Path
    
    public static function model(file:String, ?missingPrint:Bool = true):String
        return getPath('models/' + file + '.obj', missingPrint);

    public static function video(file:String, ?missingPrint:Bool = true):String
        return getPath('videos/' + file + '.mp4', missingPrint);

    public static function font(file:String, ?missingPrint:Bool = true):String
        return addCwd(getPath('fonts/' + file, missingPrint));

    public static function addCwd(path:String):String
        return path == null ? null : #if android Sys.getCwd() + '/' + #end path;
}