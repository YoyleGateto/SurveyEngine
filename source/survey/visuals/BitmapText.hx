package survey.visuals;

import flixel.graphics.frames.FlxBitmapFont;
import flixel.math.FlxPoint;
import flixel.text.FlxBitmapText;
import openfl.display.BitmapData;

class BitmapText extends FlxBitmapText {
	public var size(default, set):Float = 1;
	function set_size(Size:Float){
		if (exists) {
			scale.set(Size, Size);
	        updateHitbox();
        }
        size = Size;
	}
	public var fontPath(default, set):String = "main";
	function set_fontPath(Font:String){
		if (exists) {
			if (!Paths.exists("fonts/" +Font + ".png") || !Paths.exists("fonts/" +Font + ".json")) return;
			var bitmap = BitmapData.fromImage(Paths.library.getImage("fonts/" + Font + ".png"));
			var json = Paths.json("fonts/" + Font);
			var used = (json.used == null) ? "" : json.used;
			var pX = (json.width == null) ? Std.int(bitmap.width / used.length) : json.width;
			var pY = (json.height == null) ? bitmap.height : json.height;
		    font = FlxBitmapFont.fromMonospace(bitmap, used, FlxPoint.weak(pX, pY));
			fontPath = Font;
		}
	}
	
    public function new(X:Float = 0.0, Y:Float = 0.0, ?Font:String, ?Text:String, ?Size:Float) {
		super(X, Y, Text ?? "");
		fontPath = Font ?? "main";
        size = Size ?? 1;
    }

	public function setFormat(Font:String, ?Size:Int = 1, ?Color:FlxColor = FlxColor.WHITE, ?Alignment:String){
		if(exists) {
			fontPath = Font;
			size = Size;
			color = Color;
			if (Alignment != null) alignment = Alignment;
			return super;
		}
	}
}