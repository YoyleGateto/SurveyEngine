package core.enums;

enum abstract PrintType(String) from String to String
{
    var ERROR = 'error';
    var WARNING = 'warning';
    var DEPRECATED = 'deprecated';
    var TRACE = 'trace';
    var HSCRIPT = 'hscript';
    var MISSING_FILE = 'missing_file';
    var MISSING_FOLDER = 'missing_folder';
    var CUSTOM = 'custom';
    var POP_UP = 'pop-up';
    var RESET_STATE = 'reset_state';

    public function unnecessary():Bool
    {
        return switch (cast(this, PrintType))
        {
            case POP_UP, HSCRIPT, LUA, LOAD_SONG, LOAD_WEEK, RESET_STATE, DISCORD:
                true;
            default:
                false;
        }
    }

    public function printable():Bool
    {
        return switch (cast(this, PrintType))
        {
            case POP_UP:
                false;
            default:
                true;
        }
    }

    public function toString():String
    {
        return switch (cast(this, PrintType))
        {
            case ERROR:
                'ERROR';
            case WARNING:
                'WARNING';
            case DEPRECATED:
                'DEPRECATED';
            case TRACE:
                'TRACE';
            case HSCRIPT:
                'HSCRIPT';
            case MISSING_FILE:
                'MISSING FILE';
            case MISSING_FOLDER:
                'MISSING FOLDER';
            case POP_UP:
                'POP-UP';
            case RESET_STATE:
                'RESET STATE';
            default:
                'UNKNOWN';
        }
    }

    public function toColor():FlxColor
    {
        return switch (cast(this, PrintType))
        {
            case ERROR:
                0xFFFF5555;
            case WARNING:
                0xFFFFA500;
            case DEPRECATED:
                0xFF8000;
            case TRACE:
                0xFFFFFFFF;
            case HSCRIPT:
                0xFF88CC44;
            case MISSING_FILE:
                0xFFFF7F00;
            case MISSING_FOLDER:
                0xFFFF7F00;
            case POP_UP:
                0xFFFF00FF;
            case RESET_STATE:
                FlxColor.YELLOW;
            case BENCHMARK:
                FlxColor.PINK;
            default:
                FlxColor.GRAY;
        }
    }
}