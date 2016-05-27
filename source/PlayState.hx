package;

import haxe.zip.Reader;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class PlayState extends FlxState
{
	var currentTurn:Reg.Turn;
	var currentTurnText:FlxText;
    var guideText:FlxText;
    var errorText:FlxText;
    var allCharacters:Array<CharacterCard>;
    var doneSelectCouple = false;

	override public function create():Void
	{
        Reg.Couple = new Array();
        allCharacters = new Array();
		var gap = 5;
		var row = 0;
		var col = 0;
        var index = 0;
		for (characterType in Reg.Characters) {
			var card = new CharacterCard(37 + col*(77 + gap), 50 + row*(107 + gap), characterType);
			col += 1;
			if (col == 5) {
				col = 0;
				row += 1;
			}
			currentTurn = Reg.Turn.DISABLER;
            card.setName(Reg.PlayerNames[index]);
            index += 1;
			add(card);
            allCharacters.push(card);
		}
		var nextButton = new FlxButton(40, FlxG.height - 40, "Next", handleClick);
		add(nextButton);
		currentTurnText = new FlxText(0, FlxG.height - 40, FlxG.width);
		currentTurnText.setFormat(null, 14, 0x37322E, CENTER);
		add(currentTurnText);
        guideText = new FlxText(0, 10, FlxG.width);
        guideText.setFormat(null, 14, 0x000000, CENTER);
        add(guideText);
        errorText = new FlxText(0, FlxG.height - 80, FlxG.width);
        errorText.setFormat(null, 14, 0xFF0000, CENTER);
        add(errorText);
		super.create();
	}
    // Cave -> con bệnh -> tình yêu -> sói -> pháp sư -> phù thuỷ câm -> thám tử -> thợ săn
    function handleClick():Void
    {
        errorText.text = "";
        switch (currentTurn)
        {
            case Reg.Turn.DISABLER:
                if (getSelectedCardNums() != 1) {
                    errorText.text = "Invalid number of character !";
                    Reg.disablerTarget = null;
                } else {
                    Reg.disablerTarget = getSelectedCard();
                    trace(Reg.disablerTarget);
                    currentTurn = Reg.Turn.CURSED;
                }
            case Reg.Turn.CUPID:
                if (!doneSelectCouple) {
                    for (character in allCharacters) {
                        if (character.isSelected()) {
                            Reg.Couple.push(character);
                        }
                    }
                }
                if (Reg.Couple.length == 2) {
                    doneSelectCouple = true;
                    currentTurn = Reg.Turn.WOLF;
                } else {
                    errorText.text = "Invalid number of character !";
                    while (Reg.Couple.length != 0) Reg.Couple.pop();
                }
            case Reg.Turn.CURSED:
                currentTurn = Reg.Turn.CUPID;
            default:
        }
        clearSelectAllCards();
        showAllCards();
    }

	override public function update(elapsed:Float):Void
	{
		switch (currentTurn)
		{
            case Reg.Turn.WOLF:
                guideText.text = "Nothing to do !";
            case Reg.Turn.DISABLER:
                hideSpecificCards(Reg.Char.DISABLER);
            case Reg.Turn.CURSED:
                guideText.text = "Nothing to do !";
			case Reg.Turn.CUPID:
                guideText.text = "Please select a couple";
                if (doneSelectCouple) {
                    guideText.text = "Selected couple: " + Reg.Couple[0].getName() + " & " + Reg.Couple[1].getName();
                }
			default:
		}
		setCurrentTurnText();
		super.update(elapsed);
	}

    function getSelectedCard()
    {
        for (character in allCharacters) {
            if (character.isSelected()) {
                return character;
            }
        }

        return null;
    }

    function getSelectedCardNums(){
        var selected = 0;
        for (character in allCharacters) {
            if (character.isSelected()) {
                selected += 1;
            }
        }

        return selected;
    }

    function hideAllCards():Void
    {
        for (character in allCharacters) {
            character.hide();
        }
    }

    function showAllCards():Void
    {
        for (character in allCharacters) {
            character.show();
        }
    }

    function clearSelectAllCards():Void
    {
        for (character in allCharacters) {
            character.clearSelect();
        }
    }

    function hideSpecificCards(type:Reg.Char):Void
    {
        for (character in allCharacters) {
            if (character.type == type) {
                character.hide();
            }
        }
    }

	function setCurrentTurnText():Void{
		currentTurnText.text = "Current Turn: " + Reg.TurnNames[currentTurn];
	}
}
