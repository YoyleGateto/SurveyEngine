package utils.cool;

import flixel.tweens.FlxEase.EaseFunction;

class BasicUtil
{
	public static function inverseLerp(a, b, x):Float
	{
		return (x-a) / (b-a);
    }
	
	public static function adjustColorBrightness(color:FlxColor, factor:Float):FlxColor
	{
        var f = factor / 100;

        inline function adjust(c:Int):Int
            return f > 0 ? Std.int(c + (255 - c) * f) : Std.int(c * (1 + f));

        return FlxColor.fromRGB(adjust(color >> 16 & 0xFF), adjust(color >> 8 & 0xFF), adjust(color & 0xFF));
    }
	
	public static function playSound(path:String, ?force = false):FlxSound
	{
		var sound = FlxG.sound.load(Paths.sound(path));
		sound.play(force);
		return sound;
	}
	
	public static function reverseMin(v, max) {
		if(v > max) {
			return max + (max - v);
		} else {
			return v;
		}
	}
	
	public static function reverseMax(v, min) {
		if(v < max) {
			return min + (v - min);
		} else {
			return v;
		}
	}
	
	public static function getFramerate():Int
	{
		return Std.int(Math.floor(FlxG.elapsed == 0 ? FlxG.updateFramerate : (1 / FlxG.elapsed)));
	}
	
	public static function getIndexFromString(string, array):Int
	{
		return array.indexOf(string);
	}
	
	public static function durationByFrames(fps, length):Float
	{
		return (1 / fps) * length;
	}
	
	public static function floorDecimal(value:Float, decimals:Int):Float
		return FlxMath.roundDecimal(value, decimals);

	public static function quantize(f:Float, snap:Float):Float
	{
		return Math.fround(f * snap) / snap;
	}
	
	public static function fpsLerp(v1:Float, v2:Float, ratio:Float):Float
	{
		return FlxMath.lerp(v1, v2, fpsRatio(ratio));
	}
	
	public static function fpsRatio(ratio:Float)
	{
		return FlxMath.bound(ratio * FlxG.elapsed * 60, 0, 1);
	}
	
	public static function snapNumber(og:Float, mod:Float):Float
	{
		return Math.floor(og / mod) * mod;
	}
	
	public static function scaleToResolution(w = 640, h = 480, base_w = 640, base_h = 480):Dynamic
	{
		var scale = Math.min(w/base_w, h/base_h);
		var ww = Math.floor(w/scale);
		var hh = Math.floor(h/scale);
	    return {
	    	width: Std.int(ww),
	    	height: Std.int(hh)
		};
	}

	public static function capitalize(text:String):String
	{
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
	}
	
    public static function easeFromString(?ease:String = ''):EaseFunction
    {
        return switch(ease.toLowerCase().trim())
        {
            case 'backin':
                FlxEase.backIn;
            case 'backinout':
                FlxEase.backInOut;
            case 'backout':
                FlxEase.backOut;
            case 'bouncein':
                FlxEase.bounceIn;
            case 'bounceinout':
                FlxEase.bounceInOut;
            case 'bounceout':
                FlxEase.bounceOut;
            case 'circin':
                FlxEase.circIn;
            case 'circinout':
                FlxEase.circInOut;
            case 'circout':
                FlxEase.circOut;
            case 'cubein':
                FlxEase.cubeIn;
            case 'cubeinout':
                FlxEase.cubeInOut;
            case 'cubeout':
                FlxEase.cubeOut;
            case 'elasticin':
                FlxEase.elasticIn;
            case 'elasticinout':
                FlxEase.elasticInOut;
            case 'elasticout':
                FlxEase.elasticOut;
            case 'expoin':
                FlxEase.expoIn;
            case 'expoinout':
                FlxEase.expoInOut;
            case 'expoout':
                FlxEase.expoOut;
            case 'quadin':
                FlxEase.quadIn;
            case 'quadinout':
                FlxEase.quadInOut;
            case 'quadout':
                FlxEase.quadOut;
            case 'quartin':
                FlxEase.quartIn;
            case 'quartinout':
                FlxEase.quartInOut;
            case 'quartout':
                FlxEase.quartOut;
            case 'quintin':
                FlxEase.quintIn;
            case 'quintinout':
                FlxEase.quintInOut;
            case 'quintout':
                FlxEase.quintOut;
            case 'sinein':
                FlxEase.sineIn;
            case 'sineinout':
                FlxEase.sineInOut;
            case 'sineout':
                FlxEase.sineOut;
            case 'smoothstepin':
                FlxEase.smoothStepIn;
            case 'smoothstepinout':
                FlxEase.smoothStepInOut;
            case 'smoothstepout':
                FlxEase.smoothStepOut;
            case 'smootherstepin':
                FlxEase.smootherStepIn;
            case 'smootherstepinout':
                FlxEase.smootherStepInOut;
            case 'smootherstepout':
                FlxEase.smootherStepOut;
            default:
                FlxEase.linear;
        }
    }

    public static function intToHex(value:Int):String
    {
        #if !neko
        	return StringTools.hex(value);
        #end

        var hex = '';
        var digits = '0123456789ABCDEF';
        var n = value;

        for (i in 0...8)
        {
            var remainder = n % 16;
            if (remainder < 0)
                remainder += 16;

            hex = digits.charAt(remainder) + hex;
            n = Std.int(n / 16);
        }
        
        return hex;
    }

	public static function fromCharCode(code:Int):String
	{
		return String.fromCharCode(code);
	}
	
	public static function colorFromString(color:String):FlxColor
	{
		var hideChars = ~/[\t\n\r]/;
		var color:String = hideChars.split(color).join('').trim();
		if (color.startsWith('0x'))
			color = color.substring(color.length - 6);

		var colorNum:Null<FlxColor> = FlxColor.fromString(color);
		if(colorNum == null)
			colorNum = FlxColor.fromString('#' + color);

		return colorNum != null ? colorNum : FlxColor.WHITE;
	}

	public static function dominantColor(sprite:flixel.FlxSprite):Int
	{
		var countByColor:Map<Int, Int> = [];

		for(col in 0...sprite.frameWidth)
		{
			for (row in 0...sprite.frameHeight)
			{
				var colorOfThisPixel:Int = sprite.pixels.getPixel32(col, row);

				if (colorOfThisPixel != 0)
				{
					if(countByColor.exists(colorOfThisPixel))
						countByColor[colorOfThisPixel] = countByColor[colorOfThisPixel] + 1;
					else if (countByColor[colorOfThisPixel] != 13520687 - (2 * 13520687))
						countByColor[colorOfThisPixel] = 1;
				}
			}
		}

		var maxCount = 0;

		var maxKey:Int = 0;

		countByColor[FlxColor.BLACK] = 0;

		for(key in countByColor.keys())
		{
			if (countByColor[key] >= maxCount)
			{
				maxCount = countByColor[key];

				maxKey = key;
			}
		}

		countByColor = [];

		return maxKey;
	}
	
	public static function colorFromArray(arr:Array<Int>):Int
	{
    	return #if neko arr[0] * 0x10000 + arr[1] * 0x100 + arr[2] #else FlxColor.fromRGB(arr[0], arr[1], arr[2]) #end;
	}
	
	public static function colorLerp(from:FlxColor, to:FlxColor, ratio:Float):FlxColor
	{
		return FlxColor.interpolate(from, to, MathUtil.fpsRatio(ratio));
	}
}