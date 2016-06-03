package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;
import PlayerLabel;
import Reg;
import PlayState;

class InputNameState extends FlxState
{
    var guideText:FlxText;
    var errorText:FlxText;
    var mapping:Array<PlayerLabel>;

    override public function create():Void
    {
        trace(Reg.Characters);
        var row = 0;
        mapping = new Array();
        Reg.playerNames = new Array();
        for(characterType in Reg.Characters)
        {
            var label = new PlayerLabel(140, 40 + 30*row, characterType);
            add(label);
            row += 1;
            mapping.push(label);
        }
        var nextButton = new FlxButton(40, FlxG.height - 40, "Next", goToNextState);
        add(nextButton);
        guideText = new FlxText(0, 10, FlxG.width);
        guideText.setFormat(null, 14, 0x000000, CENTER);
        guideText.text = "Enter player name !";
        add(guideText);
        errorText = new FlxText(0, FlxG.height - 50, FlxG.width);
        errorText.setFormat(null, 8, 0xFF0000, CENTER);
        add(errorText);
        super.create();
    }

    private function goToNextState():Void
    {
        for (label in mapping) {
            if (label.getText() == "") {
                errorText.text = "Please enter all player name !";
                return;
            }
        }
        for (i in 0...mapping.length) {
            mapping[i].cleanUp();
            Reg.playerNames.push(mapping[i].getText());
        }
        FlxG.switchState(new PlayState());
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}
