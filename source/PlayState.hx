package;

import haxe.zip.Reader;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import PortionCard;

class PlayState extends FlxState
{
    var currentTurn:Reg.Turn;
    var currentTurnText:FlxText;
    var guideText:FlxText;
    var errorText:FlxText;
    var allCharacters:Array<CharacterCard>;
    var doneSelectCouple = false;
    var toxicPortion:PortionCard;
    var protectionPortion:PortionCard;
    var nightCount = 1;

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
            card.setName(Reg.PlayerNames[index]);
            index += 1;
            add(card);
            allCharacters.push(card);
        }

        currentTurn = Reg.Turn.DISABLER;

        var nextButton = new FlxButton(40, FlxG.height - 40, "Next", handleClick);
        add(nextButton);
        currentTurnText = new FlxText(0, FlxG.height - 70, FlxG.width);
        currentTurnText.setFormat(null, 14, 0x37322E, CENTER);
        add(currentTurnText);
        guideText = new FlxText(0, 10, FlxG.width);
        guideText.setFormat(null, 14, 0x000000, CENTER);
        add(guideText);
        errorText = new FlxText(0, FlxG.height - 90, FlxG.width);
        errorText.setFormat(null, 14, 0xFF0000, CENTER);
        add(errorText);

        toxicPortion = new PortionCard(FlxG.width/2 - 97, FlxG.height*0.67, Reg.Portion.TOXIC);
        toxicPortion.visible = false;
        add(toxicPortion);
        protectionPortion = new PortionCard(FlxG.width/2 + 10, FlxG.height*0.67, Reg.Portion.PROTECTION);
        protectionPortion.visible = false;
        add(protectionPortion);

        super.create();
    }

    function handleClick():Void
    {
        errorText.text = "";
        switch (currentTurn)
        {
            case Reg.Turn.DUMB_WITCH:
                if (getSelectedCardNums() != 1) {
                    errorText.text = "Invalid number of character !";
                    Reg.dumbWitchTarget = null;
                } else {
                    Reg.dumbWitchTarget = getSelectedCard();
                    trace(Reg.dumbWitchTarget);
                    currentTurn = Reg.Turn.DETECTIVE;
                }
            case Reg.Turn.SORCERER:
                if (toxicPortion.isSelected() || protectionPortion.isSelected()) {
                    if (getSelectedCardNums() != 1) {
                        errorText.text = "Invalid number of character !";
                        Reg.portionTarget = null;
                    } else {
                        Reg.portionTarget = getSelectedCard();
                        Reg.portionUsed = toxicPortion.isSelected() ? Reg.Portion.TOXIC : Reg.Portion.PROTECTION;
                        Reg.portionLeft -= 1;
                        toxicPortion.visible = false;
                        protectionPortion.visible = false;
                        currentTurn = Reg.Turn.DUMB_WITCH;
                    }
                }
            case Reg.Turn.WOLF:
                if (getSelectedCardNums() != 1 || getSelectedCard().type == Reg.Char.WOLF) {
                    errorText.text = "Invalid number of character !";
                    Reg.wolfTarget = null;
                } else {
                    Reg.wolfTarget = getSelectedCard();
                    trace(Reg.wolfTarget);
                    toxicPortion.visible = true;
                    protectionPortion.visible = true;
                    currentTurn = Reg.Turn.SORCERER;
                }
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
            case Reg.Turn.APPRENTICE:
                currentTurn = Reg.Turn.HUNTER;
            case Reg.Turn.DETECTIVE:
                currentTurn = Reg.Turn.APPRENTICE;
            case Reg.Turn.HUNTER:
                currentTurn = Reg.Turn.DAWN;
            case Reg.Turn.DAWN:
                currentTurn = Reg.Turn.HANGING;
            case Reg.Turn.HANGING:
                currentTurn = Reg.Turn.TWILIGHT;
            case Reg.Turn.TWILIGHT:
                nightCount += 1;
                currentTurn = Reg.Turn.DISABLER;
            default:
        }
        clearSelectAllCards();
        showAllCards();
    }

    override public function update(elapsed:Float):Void
    {
        switch (currentTurn)
        {
            case Reg.Turn.DETECTIVE:
                guideText.text = "Pick 3 character to guess";
            case Reg.Turn.DUMB_WITCH:
                guideText.text = "Pick a target to dumb";
            case Reg.Turn.SORCERER:
                guideText.text = "Optional: pick a portion, then pick a target";
                if (toxicPortion.isSelected()) {
                    protectionPortion.clearSelect();
                }
                if (protectionPortion.isSelected()) toxicPortion.clearSelect();
            case Reg.Turn.WOLF:
                guideText.text = "Pick a target to attack";
                hideSpecificCards(Reg.Char.WOLF);
            case Reg.Turn.DISABLER:
                guideText.text = "Pick a character to disable";
                hideSpecificCards(Reg.Char.DISABLER);
            case Reg.Turn.CURSED:
                guideText.text = "Nothing to do !";
            case Reg.Turn.HUNTER:
                guideText.text = "Nothing to do !";
            case Reg.Turn.APPRENTICE:
                guideText.text = "Pick a character to be your master";
                hideSpecificCards(Reg.Char.APPRENTICE);
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
        switch (currentTurn)
        {
            case Reg.Turn.DAWN:
                currentTurnText.text = Reg.TurnNames[currentTurn];
            case Reg.Turn.HANGING:
                currentTurnText.text = Reg.TurnNames[currentTurn];
            case Reg.Turn.TWILIGHT:
                currentTurnText.text = Reg.TurnNames[currentTurn];
            default:
                currentTurnText.text = "Night " + nightCount + "\n" + "Current Turn: " + Reg.TurnNames[currentTurn];
        }
    }
}
