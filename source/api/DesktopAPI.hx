package api;

@:build(core.macros.FunctionsMergeMacro.build(
	[
		'winapi.WindowsAPI',
		'winapi.gdi.WindowsGDI'
	],
	[
		'allocConsole::showConsole',
		'sendWindowsNotification::sendNotification',
		'resetWindowsFuncs::reset'
	]
))
class DesktopAPI 
{
	public static function setWindowTitle()
	{
		#if allowWindowsAPI
			winapi.WindowsCPP.reDefineMainWindowTitle(lime.app.Application.current.window.title);
		#end
	}
}