#if !macro
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

import flixel.graphics.FlxGraphic;

import api.MobileAPI;
import api.DesktopAPI;

using StringTools;
#end