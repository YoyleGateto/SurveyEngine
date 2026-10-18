#if !macro
import flixel.util.typeLimit.OneOfTwo;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxAxes;
import flixel.sound.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;

import core.enums.PrintType;
import utils.cool.LogUtil.debugTrace;

import core.assets.Paths;
import core.config.Save;

import utils.Utility;
import utils.Vars;
import utils.Keys;
import utils.SequenceHandler;
import utils.Json;

import core.game.State;
import core.game.SubState;

import survey.states.CustomState;
import survey.substates.CustomSubState;

import survey.visuals.BitmapText;
import survey.visuals.Camera;

import flixel.graphics.FlxGraphic;

import api.MobileAPI;
import api.DesktopAPI;

import haxe.ds.StringMap;

using StringTools;
#end