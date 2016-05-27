package ;
import flixel.text.FlxText;
import flixel.FlxG;
import openfl.text.TextFieldType;
import flixel.util.FlxColor;
import openfl.text.TextField;
import flixel.group.FlxSpriteGroup;

class PlayerLabel extends FlxSpriteGroup{

    var tf:TextField;
    var characterClass:FlxText;
    var type:Reg.Char;

    public function new(X:Float, Y:Float, type:Reg.Char) {
        super(X, Y);
        this.type = type;
        characterClass = new FlxText(0, 0, 100);
        characterClass.text = Reg.Names[type] + ": ";
        characterClass.setFormat(null, 8, 0x37322E, RIGHT);
        add(characterClass);
        tf = new TextField();
        tf.width = 60;
        tf.background = true;
        tf.height = 20;
        tf.x = X + 100;
        tf.y = Y;
        tf.backgroundColor = FlxColor.WHITE;
        tf.type = TextFieldType.INPUT;
        FlxG.addChildBelowMouse(tf);
    }

    public function getText():String
    {
        return tf.text;
    }

    public function cleanUp(){
        FlxG.removeChild(tf);
    }
}
