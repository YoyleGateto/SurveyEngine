package core.plugins;

import survey.debug.DebugPrintText;

class DebugPrintPlugin extends FlxTypedGroup<DebugPrintText>
{
    public function print(debugText:String, ?prefix:String, ?color:FlxColor)
    {
        var text:DebugPrintText = recycle(DebugPrintText);

        members.remove(text);
        members.push(text);

        text.setData(debugText, prefix, color);
        
        var curHeight:Float = FlxG.height - 4;

        for (i in 1...(members.length + 1))
        {
            var obj:DebugPrintText = members[members.length - i];
            
            curHeight -= obj.height + 2;

            if (curHeight <= -obj.height)
                obj.kill();

            obj.y = curHeight;
        }
    }
}