package survey.debug;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class DebugCounter extends Sprite
{
    final label:TextField;

    public function new()
    {
        super();
        
        x = 8;
        y = 8;
        
        label = new TextField();
        label.antiAliasType = ADVANCED;
        label.sharpness = 200;
        label.selectable = label.mouseEnabled = false;
        label.autoSize = LEFT;
        label.multiline = true;
        label.defaultTextFormat = new TextFormat(Paths.font('main.ttf'), 16, FlxColor.WHITE);
        label.x = 4;
        label.y = 4;
        
        addChild(label);

        showBG = false;
        
        FlxG.stage.addEventListener('enterFrame', update);
    }

    var currentWidth:Float = 0;
    var currentHeight:Float = 0;

    public var showBG(default, set):Bool;
    function set_showBG(value:Bool):Bool
    {
        showBG = value;

        if (!showBG)
            graphics.clear();
        else
            update(null, true);

        return showBG;
    }

    public function update(?_, ?force:Bool = false);
    {
        label.text = Std.string(Math.floor(1 / (FlxG.elapsed <= 0 ? 1 : FlxG.elapsed))) + "FPS\n" + (Paths.mod == null ? '' : Paths.mod) + (Vars.data.developerMode ? ' [DEV]' : '');

        if (label.width != currentWidth || label.height != currentHeight || force)
        {
            currentWidth = label.width;
            currentHeight = label.height;

            if (showBG)
            {
                graphics.clear();
                graphics.lineStyle(2, FlxColor.WHITE, 0.5);
                graphics.beginFill(FlxColor.BLACK, 0.5);
                graphics.drawRect(0, 0, currentWidth + 8, currentHeight + 8);
                graphics.endFill();
            }
        }
    }

    public function destroy()
    {
        for (i in 0...numChildren)
        {
            final child = getChildAt(i);
            removeChild(child);
        }
        
        graphics.clear();
        
        FlxG.stage.removeEventListener('enterFrame', update);
    }
}