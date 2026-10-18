package core.structures;

typedef OptionData = {
    var id:String;
    var name:String;
    var type:String;
    var value:Dynamic;
    @optional var step:OneOfTwo<Int, Float>;
    @optional var min:OneOfTwo<Int, Float>;
    @optional var max:OneOfTwo<Int, Float>;
    @optional var strings:Array<String>;
}