package scripting;

import rulescript.scriptedClass.RuleScriptedClass;

import flixel.*;
import flixel.util.*;
import flixel.text.*;
import flixel.math.*;
import flixel.group.*;
import flixel.ui.*;
import flixel.graphics.*;
import flixel.addons.display.*;
import flixel.input.keyboard.*;
import flixel.input.*;

import openfl.display.*;
import openfl.utils.*;
import openfl.text.*;

import survey.visuals.*;

private typedef FlxDrawItem = flixel.graphics.tile.FlxDrawQuadsItem;

private typedef LimeAssetLibrary = lime.utils.AssetLibrary;

class Extensible {}

class ScriptedFlxBasic extends FlxBasic implements RuleScriptedClass {}
class ScriptedFlxObject extends FlxObject implements RuleScriptedClass {}
class ScriptedFlxGroup extends FlxGroup implements RuleScriptedClass {}
class ScriptedFlxSpriteGroup extends FlxSpriteGroup implements RuleScriptedClass {}
class ScriptedFlxTimer extends FlxTimer implements RuleScriptedClass {}
class ScriptedFlxSound extends FlxSound implements RuleScriptedClass {}
class ScriptedFlxRect extends FlxRect implements RuleScriptedClass {}
class ScriptedFlxButton extends FlxButton implements RuleScriptedClass {}
class ScriptedFlxBar extends FlxBar implements RuleScriptedClass {}
class ScriptedFlxGraphic extends FlxGraphic implements RuleScriptedClass {}
class ScriptedFlxSprite extends FlxSprite implements RuleScriptedClass {}
class ScriptedFlxBackdrop extends FlxBackdrop implements RuleScriptedClass {}
class ScriptedFlxRuntimeShader extends FlxRuntimeShader implements RuleScriptedClass {}
class ScriptedFlxText extends FlxText implements RuleScriptedClass {}
class ScriptedFlxBitmapText extends FlxBitmapText implements RuleScriptedClass {}
class ScriptedFlxTextFormat extends FlxTextFormat implements RuleScriptedClass {}
class ScriptedFlxCamera extends FlxCamera implements RuleScriptedClass {}

class ScriptedFlxKeyList extends FlxKeyList implements RuleScriptedClass {}
class ScriptedFlxBaseKeyList extends FlxBaseKeyList implements RuleScriptedClass {}

@:forceOverride class ScriptedOpenFLSprite extends Sprite implements RuleScriptedClass {}
@:forceOverride class ScriptedOpenFLTextField extends TextField implements RuleScriptedClass {}

class ScriptedCamera extends Camera implements RuleScriptedClass {}
class ScriptedRuntimeShader extends RuntimeShader implements RuleScriptedClass {}
class ScriptedShader extends Shader implements RuleScriptedClass {}