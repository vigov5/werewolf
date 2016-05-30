package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import CharacterCard;
import Reg;


class MenuState extends FlxState
{
    var initialCharacterTypes:Array<Reg.Char> = [
        Reg.Char.WOLF,
        Reg.Char.WOLF,
        Reg.Char.WOLF,
        Reg.Char.WOLF,
        Reg.Char.VILLAGER,
        Reg.Char.HUNTER,
        Reg.Char.DETECTIVE,
        Reg.Char.SORCERER,
        Reg.Char.DUMB_WITCH,
        Reg.Char.APPRENTICE,
        Reg.Char.CUPID,
        Reg.Char.CURSED,
        Reg.Char.DISABLER
    ];
    var initialCharacters:Array<CharacterCard>;
    var guideText:FlxText;
    var errorText:FlxText;

    override public function create():Void
    {
        FlxG.camera.bgColor =  0xFFF4EBE2;
        Reg.Characters = new Array();
        initialCharacters = new Array();
        FlxG.camera.bgColor = 0x000000;
        var gap = 5;
        var row = 0;
        var col = 0;
        for (characterType in initialCharacterTypes) {
            var card = new CharacterCard(37 + col*(77 + gap), 50 + row*(107 + gap), characterType);
            col += 1;
            if (col == 5) {
                col = 0;
                row += 1;
            }
            add(card);
            initialCharacters.push(card);
        }
        var nextButton = new FlxButton(40, FlxG.height - 40, "Next", goToNextState);
        add(nextButton);
        guideText = new FlxText(0, 10, FlxG.width);
        guideText.setFormat(null, 14, 0x000000, CENTER);
        add(guideText);
        errorText = new FlxText(0, FlxG.height - 80, FlxG.width);
        errorText.setFormat(null, 14, 0xFF0000, CENTER);
        add(errorText);
        super.create();
    }

    private function goToNextState():Void{
        var selectedNums = 0;
        for (card in initialCharacters) {
            if (card.isSelected()) {
                Reg.Characters.push(card.type);
                selectedNums += 1;
            }
        }
        if (selectedNums == 0) {
            errorText.text = "Please select enough card !";
        } else {
            FlxG.switchState(new InputNameState());
        }
    }

    override public function update(elapsed:Float):Void
    {
        var selectedNums = 0;
        for (card in initialCharacters) {
            if (card.isSelected()) {
                selectedNums += 1;
            }
        }
        guideText.text = "Please select cards (" + selectedNums + ")";
        super.update(elapsed);
    }
}
