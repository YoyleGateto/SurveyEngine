package core.macros;

import haxe.macro.Context;
import haxe.macro.Compiler;

class ImportsMacro
{
	public static function include()
	{
        #if COMPILE_ALL_CLASSES
        var packs:Array<String> = [
            'sys',
            'sys.io',
            
            'openfl',
            'openfl.net',

            'flixel.util',
            'flixel.ui',
            'flixel.tweens',
            'flixel.tile',
            'flixel.text',
            'flixel.sound',
            'flixel.path',
            'flixel.math',
            'flixel.input',
            'flixel.group',
            'flixel.graphics',
            'flixel.effects',
            'flixel.effects.particles',
            'flixel.animation',

            'flixel.addons.api',
            'flixel.addons.display',
            'flixel.addons.display.shapes',
            'flixel.addons.effects',
            'flixel.addons.ui',
            'flixel.addons.plugin',
            'flixel.addons.text',
            'flixel.addons.tile',
            'flixel.addons.transition',
            'flixel.addons.util',
            'flixel.addons.editors.ogmo',

            'flixel.sound.filters',
            'flixel.sound.filters.effects',

            'haxe.crypto',
            'haxe.display',
            'haxe.exceptions',
            'haxe.extern',
            'haxe.ds',
            'haxe.sys',
            'haxe.sys.io',
            'haxe.runtime',

            'utils',
            'utils.cool',

			'survey.visuals',
            'survey.visuals.options',
            'survey.mobile',
            'survey.debug',
            'survey.states',
            'survey.substates'
        ];

        for (pack in packs)
            Compiler.include(pack);
        #end
	}
}