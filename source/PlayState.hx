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
    var summaryText:FlxText;
    var allCharacters:Array<CharacterCard>;
    var doneSelectCouple = false;
    var toxicPortion:PortionCard;
    var protectionPortion:PortionCard;
    var nightCount = 1;
    var cursedUpgraded = false;
    var hunterIsDead = false;
    var apprenticeUpgraded = false;

    override public function create():Void
    {
        Reg.couple = new Array();
        allCharacters = new Array();
        Reg.characterMapping = new Map();
        Reg.wolfs = new Array();
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
            card.setName(Reg.playerNames[index]);
            index += 1;
            add(card);
            allCharacters.push(card);
            if (card.type == Reg.Char.WOLF) {
                Reg.wolfs.push(card);
            } else {
                Reg.characterMapping[card.type] = card;
            }
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
        summaryText = new FlxText(0, 30, FlxG.width);
        summaryText.setFormat(null, 14, 0x37322E, CENTER);
        summaryText.visible = false;
        add(summaryText);

        toxicPortion = new PortionCard(FlxG.width/2 - 97, FlxG.height*0.67, Reg.Portion.TOXIC);
        toxicPortion.visible = false;
        add(toxicPortion);
        protectionPortion = new PortionCard(FlxG.width/2 + 10, FlxG.height*0.67, Reg.Portion.PROTECTION);
        protectionPortion.visible = false;
        add(protectionPortion);

        // setTestState();
        // currentTurn = Reg.Turn.HUNTER;

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
                    summaryText.text += Reg.characterMapping[Reg.Char.DISABLER].getFullName() + " want " + Reg.dumbWitchTarget.getFullName() + " to be silenced\n";
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
                    summaryText.text += Reg.characterMapping[Reg.Char.DISABLER].getFullName() + " want to sleep with " + Reg.disablerTarget.getFullName() + "\n";
                    currentTurn = Reg.Turn.CURSED;
                }
            case Reg.Turn.CUPID:
                if (!doneSelectCouple) {
                    for (character in allCharacters) {
                        if (character.isSelected()) {
                            Reg.couple.push(character);
                        }
                    }
                }
                if (Reg.couple.length == 2) {
                    summaryText.text += Reg.couple[0].getFullName() + " and " + Reg.couple[1].getFullName() + " is a couple\n";
                    doneSelectCouple = true;
                    currentTurn = Reg.Turn.WOLF;
                } else {
                    errorText.text = "Invalid number of character !";
                    while (Reg.couple.length != 0) Reg.couple.pop();
                }
            case Reg.Turn.CURSED:
                currentTurn = Reg.Turn.CUPID;
            case Reg.Turn.APPRENTICE:
                if (getSelectedCardNums() != 1) {
                    errorText.text = "Invalid number of character !";
                    Reg.apprenticeTarget = null;
                } else {
                    Reg.apprenticeTarget = getSelectedCard();
                    summaryText.text += Reg.apprenticeTarget.getFullName() + " is master of " + Reg.characterMapping[Reg.Char.APPRENTICE].getFullName() + "\n";
                    trace(Reg.apprenticeTarget);
                    currentTurn = Reg.Turn.HUNTER;
                }
            case Reg.Turn.DETECTIVE:
                currentTurn = Reg.Turn.APPRENTICE;
            case Reg.Turn.HUNTER:
                updateGameState();
                summaryText.visible = true;
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
                    guideText.text = "Selected couple: " + Reg.couple[0].getName() + " & " + Reg.couple[1].getName();
                }
            case Reg.Turn.DAWN:
                hideAllCards();
            default:
        }
        setCurrentTurnText();
        super.update(elapsed);
    }

    function setTestState()
    {
        /* wolf, wolf, wolf, dis, so, witch, cupid, hunter, cus

        */
        doneSelectCouple = true;
        Reg.couple = [];
        Reg.couple.push(Reg.characterMapping[Reg.Char.DETECTIVE]);
        Reg.couple.push(Reg.characterMapping[Reg.Char.HUNTER]);
        // Set disable
        Reg.disablerTarget = Reg.wolfs[0];
        Reg.wolfTarget = Reg.characterMapping[Reg.Char.DETECTIVE];
        // Set protection
        Reg.portionTarget = Reg.characterMapping[Reg.Char.DETECTIVE];
        Reg.portionUsed = Reg.Portion.TOXIC;
    }

    function isProtected(character:CharacterCard){
        return !Reg.characterMapping[Reg.Char.SORCERER].isDisabled && Reg.portionTarget == character && Reg.portionUsed == Reg.Portion.PROTECTION;
    }

    function isPoisoned(character:CharacterCard){
        return !Reg.characterMapping[Reg.Char.SORCERER].isDisabled && Reg.portionTarget == character && Reg.portionUsed == Reg.Portion.TOXIC;
    }

    function updateGameState()
    {
        var deadMans:Array<CharacterCard> = new Array();
        // check disable target
        summaryText.text += "\n--- Result ---\n\n";
        if (Reg.disablerTarget != null) {
            Reg.disablerTarget.isDisabled = true;
            summaryText.text += Reg.characterMapping[Reg.Char.DISABLER].getFullName() + " slept with " + Reg.disablerTarget.getFullName() + "\n";
        }

        if (Reg.wolfs.length == 1 && Reg.disablerTarget.type == Reg.Char.WOLF) {
            summaryText.text += "One disabled wolf can't do anything !\n";
        } else {
            summaryText.text += "Wolfs choose to kill " + Reg.wolfTarget.getFullName() + " !\n";
            // protected by sorcerer
            if (isProtected(Reg.wolfTarget)) {
                summaryText.text += Reg.wolfTarget.getFullName() + " is protected\n";
            } else if (isPoisoned(Reg.wolfTarget)) {
                summaryText.text += Reg.wolfTarget.getFullName() + " is poisoned\n";
                deadMans.push(Reg.wolfTarget);
            } else {
                deadMans.push(Reg.wolfTarget);
            }
        }

        if (isPoisoned(Reg.portionTarget)) {
            summaryText.text += Reg.portionTarget.getFullName() + " is poisoned and died\n";
            pushIfNotExist(deadMans, Reg.portionTarget);
        }

        trace(deadMans);

        for (character in deadMans) {
            var lovedOne = getLover(character);
            if (lovedOne != null){
                summaryText.text += lovedOne.getFullName() + " is in love with " + character.getFullName() + ".\n";
                if (isProtected(lovedOne)) {
                    summaryText.text += lovedOne.getFullName() + " is protected\n";
                } else {
                    if (isPoisoned(lovedOne)) {
                        summaryText.text += lovedOne.getFullName() + " is poisoned and died\n";
                    }
                    summaryText.text += lovedOne.getFullName() + " died of broken heart\n";
                    pushIfNotExist(deadMans, lovedOne);
                }
                break;
            }
        }

        for (character in deadMans) {
            if (character.type == Reg.Char.CURSED) {
                cursedUpgraded = true;
                summaryText.text += character.getFullName() + " became wolf.\n";
            } else {
                if (character.type == Reg.Char.HUNTER) {
                    hunterIsDead = true;
                }
                if (character == Reg.apprenticeTarget && !apprenticeUpgraded) {
                    summaryText.text += character.getFullName() + " is dead\n";
                    summaryText.text += Reg.characterMapping[Reg.Char.APPRENTICE] + " became " + Reg.Names[character.type] + "\n";
                    apprenticeUpgraded = true;
                }
                if (character == Reg.dumbWitchTarget && !Reg.characterMapping[Reg.Char.DUMB_WITCH].isDisabled) {
                    summaryText.text += character.getFullName() + " is silenced\n";
                }
                summaryText.text += character.getFullName() + " is dead\n";
            }
        }

        trace(deadMans);
        trace(summaryText.text);
    }

    function pushIfNotExist(container:Array<CharacterCard>, item:CharacterCard)
    {
        if (container.indexOf(item) == -1) {
            container.push(item);
        }
    }

    function getLover(character:CharacterCard){
        if (!Reg.characterMapping[Reg.Char.CUPID].isDisabled) {
            if (Reg.couple.indexOf(character) != -1) {
                return Reg.couple.filter(function(v){ return v != character; })[0];
            } else {
                return null;
            }
        } else {
            return null;
        }
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
