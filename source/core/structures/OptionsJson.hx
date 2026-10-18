package core.structures;

import core.structures.CategoryData;
import core.structures.KeybindData;

typedef OptionsJson = {
    var keybinds:Array<KeybindData>;
    var options:Array<CategoryData>;
}