package utils;

import flixel.input.keyboard.FlxKey;

import core.config.Save;

import core.Main;

@:build(core.macros.FunctionsMergeMacro.build(
	[
		'utils.cool.BasicUtil',
		'utils.cool.CameraUtil',
		'utils.cool.EngineUtil',
		'utils.cool.FileUtil',
		'utils.cool.LogUtil',
		'utils.cool.MapUtil',
		'utils.cool.ReflectUtil',
		'utils.cool.StateUtil',
		'utils.cool.SystemUtil',
	]
))
class Utility
{
	public static function resetGame()
	{
		Main.preResetConfig();
		FlxG.resetGame();
	}
}