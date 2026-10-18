package core.interfaces;

import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import flixel.FlxBasic.IFlxBasic;

interface ITactileButton extends IFlxBasic extends IFlxDestroyable
{
    public var pressed:Bool;
    public var justPressed:Bool;
    public var justReleased:Bool;

    public function restart():Void;
}