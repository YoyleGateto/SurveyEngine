package api;

import flixel.input.keyboard.FlxKey;

import core.plugins.MobileControlsPlugin;

import core.enums.KeyCheck;

import core.Main;

class MobileAPI
{
    public static var controls(get, never):MobileControlsPlugin;
    static function get_controls():MobileControlsPlugin
        return Main.mobileControlsPlugin;

    public static function restartControls()
        controls?.restartControls();

    public static function destroyControls()
        controls?.destroyControls();

    public static function toggleControls(show:Bool)
        controls?.toggleControls(show);

    public static function initControls()
        controls?.initControls();
        
    public static function updateControls()
        controls?.updateControls();

    public static function checkKey(key:String, prop:KeyCheck):Bool
        return controls == null ? false : controls.checkKey(key, prop);
}