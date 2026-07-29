package core;

import flixel.util.typeLimit.NextState.InitialState;
import flixel.FlxGame;

import api.DesktopAPI;

import core.backend.SoundTray;

import funkin.substates.ModsMenuSubState;

import openfl.events.FullScreenEvent;

import lime.app.Application;

class Program extends FlxGame
{
	override public function new(initial:InitialState)
	{
		super(640, 480, initial, 30, 30, true, false);

		_customSoundTray = SoundTray;
	}
	
	@:unreflective var visibleConsole:Bool = false;

	override public function update()
	{
		DesktopAPI.setWindowTitle();

		super.update();

		if (FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT)
		{
			if (CoolVars.data.developerMode)
			{
				if (FlxG.keys.justPressed.R)
					Utility.resetGame();
			}

			if (!Paths.disableMods)
			{
				if (FlxG.keys.justPressed.M)
				{
					if (FlxG.state.subState != null)
						FlxG.state.subState.close();
	
					CoolUtil.switchState(new survey.states.ModSelectState(), true);
				}
			}
		}

		#if allowWindowsAPI
		if (FlxG.keys.justPressed.F9)
		{
			if (!visibleConsole)
				DesktopAPI.showConsole();

			visibleConsole = true;
		}
		#end
	}
}