package utils;

import api.MobileAPI;

class Keys
{

	// DIRECTIONS

	public static var UP(get, never):Bool;
	static function get_UP():Bool {
		return FlxG.keys.pressed.UP || MobileAPI.checkKey("up", PRESSED);
	}
	public static var DOWN(get, never):Bool;
	static function get_DOWN():Bool {
		return FlxG.keys.pressed.DOWN || MobileAPI.checkKey("down", PRESSED);
	}
	public static var LEFT(get, never):Bool;
	static function get_LEFT():Bool {
		return FlxG.keys.pressed.LEFT || MobileAPI.checkKey("left", PRESSED);
	}
	public static var RIGHT(get, never):Bool;
	static function get_RIGHT():Bool {
		return FlxG.keys.pressed.RIGHT || MobileAPI.checkKey("right", PRESSED);
	}
	
	public static var UP_P(get, never):Bool;
	static function get_UP_P():Bool {
		return FlxG.keys.justPressed.UP || MobileAPI.checkKey("up", JUST_PRESSED);
	}
	public static var DOWN_P(get, never):Bool;
	static function get_DOWN_P():Bool {
		return FlxG.keys.justPressed.DOWN || MobileAPI.checkKey("down", JUST_PRESSED);
	}
	public static var LEFT_P(get, never):Bool;
	static function get_LEFT_P():Bool {
		return FlxG.keys.justPressed.LEFT || MobileAPI.checkKey("left", JUST_PRESSED);
	}
	public static var RIGHT_P(get, never):Bool;
	static function get_RIGHT_P():Bool {
		return FlxG.keys.justPressed.RIGHT || MobileAPI.checkKey("right", JUST_PRESSED);
	}
	
	public static var UP_R(get, never):Bool;
	static function get_UP_R():Bool {
		return FlxG.keys.justReleased.UP || MobileAPI.checkKey("up", JUST_RELEASED);
	}
	public static var DOWN_R(get, never):Bool;
	static function get_DOWN_R():Bool {
		return FlxG.keys.justReleased.DOWN || MobileAPI.checkKey("down", JUST_RELEASED);
	}
	public static var LEFT_R(get, never):Bool;
	static function get_LEFT_R():Bool {
		return FlxG.keys.justReleased.LEFT || MobileAPI.checkKey("left", JUST_RELEASED);
	}
	public static var RIGHT_R(get, never):Bool;
	static function get_RIGHT_R():Bool {
		return FlxG.keys.justReleased.RIGHT || MobileAPI.checkKey("right", JUST_RELEASED);
	}
	
	// ACCEPT, BACK, MENU
	
	public static var ACCEPT_P(get, never):Bool;
	static function get_ACCEPT_P():Bool {
		return MobileAPI.checkKey("accept", JUST_PRESSED) || FlxG.keys.justPressed.Z;
	}
	public static var ACCEPT(get, never):Bool;
	static function get_ACCEPT():Bool {
		return MobileAPI.checkKey("accept", PRESSED) || FlxG.keys.pressed.Z;
	}
	public static var ACCEPT_R(get, never):Bool;
	static function get_ACCEPT_R():Bool {
		return MobileAPI.checkKey("accept", JUST_RELEASED) || FlxG.keys.justReleased.Z;
	}
	
	public static var BACK_P(get, never):Bool;
	static function get_BACK_P():Bool {
		return MobileAPI.checkKey("back", JUST_PRESSED) || FlxG.keys.justPressed.X;
	}
	public static var BACK(get, never):Bool;
	static function get_BACK():Bool {
		return MobileAPI.checkKey("back", PRESSED) || FlxG.keys.pressed.X;
	}
	public static var BACK_R(get, never):Bool;
	static function get_BACK_R():Bool {
		return MobileAPI.checkKey("back", JUST_RELEASED) || FlxG.keys.justReleased.X;
	}
	
	public static var MENU_P(get, never):Bool;
	static function get_MENU_P():Bool {
		return MobileAPI.checkKey("menu", JUST_PRESSED) || FlxG.keys.justPressed.C;
	}
	public static var MENU(get, never):Bool;
	static function get_MENU():Bool {
		return MobileAPI.checkKey("menu", PRESSED) || FlxG.keys.pressed.C;
	}
	public static var MENU_R(get, never):Bool;
	static function get_MENU_R():Bool {
		return MobileAPI.checkKey("menu", JUST_RELEASED) || FlxG.keys.justReleased.C;
	}
}