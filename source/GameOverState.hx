package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import CharacterCard;
import Reg;


class GameOverState extends FlxState
{
    var resultText:FlxText;
    var errorText:FlxText;

    override public function create():Void
    {
        FlxG.camera.bgColor =  0xFFF4EBE2;
        var newButton = new FlxButton(FlxG.width/2 - 40, FlxG.height - 80, "New Game", goToNextState);
        add(newButton);
        resultText = new FlxText(0, FlxG.height/2, FlxG.width);
        resultText.setFormat(null, 28, 0x000000, CENTER);
        if (Reg.gameResult == Reg.Game.VILLAGERS_WON) {
            resultText.text = "Villagers Won !";
        } else if (Reg.gameResult == Reg.Game.WOLFS_WON) {
            resultText.text = "Wolfs Won !";
        } else {
            resultText.text = "???";
        }
        add(resultText);
        super.create();
    }

    private function goToNextState():Void
    {
        Reg.playerNames = new Array();
        Reg.disablerTarget = null;
        Reg.apprenticeTarget = null;
        Reg.wolfTarget = null;
        Reg.portionLeft = 2;
        Reg.portionUsed = null;
        Reg.portionTarget = null;
        Reg.spellcasterTarget = null;
        Reg.hunterTarget = null;
        Reg.hangingTarget = null;
        Reg.characterMapping = new Map();
        Reg.wolfs = new Array();
        Reg.gameResult = Reg.Game.NEW;
        FlxG.switchState(new MenuState());
    }
}
