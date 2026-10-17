package core.game;

import flixel.FlxSubState;

class SubState extends FlxSubState
{
    public var subCam:Camera;

    override function create()
    {
        super.create();
		FlxG.cameras.add(subCam = new Camera(), false);
    }

	override function destroy()
	{
        FlxG.cameras.remove(subCam, true);
		super.destroy();
	}
}