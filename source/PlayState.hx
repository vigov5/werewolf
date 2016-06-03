package;

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
    var doneSelectMaster = false;
    var toxicPortion:PortionCard;
    var protectionPortion:PortionCard;
    var nightCount = 1;
    var cursedUpgraded = false;
    var hunterIsDead = false;
    var hunterFuneralIsDone = false;
    var hangingIsDone = false;
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
            card.setPlayerName(Reg.playerNames[index]);
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
        currentTurnText = new FlxText(0, FlxG.height - 80, FlxG.width);
        currentTurnText.setFormat(null, 14, 0x37322E, CENTER);
        add(currentTurnText);
        guideText = new FlxText(0, 10, FlxG.width);
        guideText.setFormat(null, 14, 0x000000, CENTER);
        add(guideText);
        errorText = new FlxText(0, FlxG.height - 100, FlxG.width);
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

        //setTestState();
        //currentTurn = Reg.Turn.HUNTER;

        super.create();
    }

    function handleClick():Void
    {
        errorText.text = "";
        switch (currentTurn)
        {
            case Reg.Turn.SPELLCASTER:
                if (Reg.characterMapping[Reg.Char.SPELLCASTER].isDead) {
                    currentTurn = Reg.Turn.DETECTIVE;
                } else {
                    if (getSelectedCardNums() != 1) {
                        errorText.text = "Invalid number of character !";
                        Reg.spellcasterTarget = null;
                    } else {
                        Reg.spellcasterTarget = getSelectedCard();
                        summaryText.text += Reg.characterMapping[Reg.Char.SPELLCASTER].getFullName() + " want " + Reg.spellcasterTarget.getFullName() + " to be silenced\n";
                        trace(Reg.spellcasterTarget);
                        currentTurn = Reg.Turn.DETECTIVE;
                    }
                }
            case Reg.Turn.SORCERER:
                if (Reg.portionLeft == 0 || Reg.characterMapping[Reg.Char.SORCERER].isDead) {
                    currentTurn = Reg.Turn.SPELLCASTER;
                    toxicPortion.visible = false;
                    protectionPortion.visible = false;
                } else {
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
                            currentTurn = Reg.Turn.SPELLCASTER;
                        }
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
                if (Reg.characterMapping[Reg.Char.DISABLER].isDead) {
                    currentTurn = Reg.Turn.CURSED;
                } else {
                    if (getSelectedCardNums() != 1) {
                        errorText.text = "Invalid number of character !";
                        Reg.disablerTarget = null;
                    } else {
                        Reg.disablerTarget = getSelectedCard();
                        trace(Reg.disablerTarget);
                        summaryText.text += Reg.characterMapping[Reg.Char.DISABLER].getFullName() + " want to sleep with " + Reg.disablerTarget.getFullName() + "\n";
                        currentTurn = Reg.Turn.CURSED;
                    }
                }
            case Reg.Turn.CUPID:
                if (Reg.characterMapping[Reg.Char.CUPID].isDead) {
                    currentTurn = Reg.Turn.WOLF;
                } else {
                    if (Reg.couple.length != 2) {
                        for (character in allCharacters) {
                            if (character.isSelected()) {
                                Reg.couple.push(character);
                            }
                        }
                    }
                    if (Reg.couple.length == 2) {
                        summaryText.text += Reg.couple[0].getFullName() + " and " + Reg.couple[1].getFullName() + " is a couple\n";
                        currentTurn = Reg.Turn.WOLF;
                    } else {
                        errorText.text = "Invalid number of character !";
                        while (Reg.couple.length != 0) Reg.couple.pop();
                    }
                }
            case Reg.Turn.CURSED:
                currentTurn = Reg.Turn.CUPID;
            case Reg.Turn.APPRENTICE:
                if (doneSelectMaster) {
                    currentTurn = Reg.Turn.HUNTER;
                } else {
                    if (getSelectedCardNums() != 1) {
                        errorText.text = "Invalid number of character !";
                        Reg.apprenticeTarget = null;
                    } else {
                        Reg.apprenticeTarget = getSelectedCard();
                        summaryText.text += Reg.apprenticeTarget.getFullName() + " is master of " + Reg.characterMapping[Reg.Char.APPRENTICE].getFullName() + "\n";
                        trace(Reg.apprenticeTarget);
                        doneSelectMaster = true;
                        currentTurn = Reg.Turn.HUNTER;
                    }
                }
            case Reg.Turn.DETECTIVE:
                currentTurn = Reg.Turn.APPRENTICE;
            case Reg.Turn.HUNTER:
                updateDawnState();
                summaryText.visible = true;
                currentTurn = Reg.Turn.DAWN;
            case Reg.Turn.DAWN:
                summaryText.visible = false;
                if (hunterIsDead && !hunterFuneralIsDone) {
                    currentTurn = Reg.Turn.FUNERAL;
                } else {
                    currentTurn = Reg.Turn.HANGING;
                }
            case Reg.Turn.FUNERAL:
                checkGameOver();
                if (getSelectedCardNums() != 1) {
                    errorText.text = "Invalid number of character !";
                    Reg.hunterTarget = null;
                } else {
                    Reg.hunterTarget = getSelectedCard();
                    trace(Reg.hunterTarget);
                    summaryText.text += Reg.characterMapping[Reg.Char.HUNTER].getFullName() + " want " + Reg.hunterTarget.getFullName() + " to follow him\n";
                    updateFuneralState();
                    summaryText.visible = true;
                    hunterFuneralIsDone = true;
                    currentTurn = Reg.Turn.MIDDAY;
                }
            case Reg.Turn.MIDDAY:
                checkGameOver();
                summaryText.visible = false;
                if (hangingIsDone) {
                    currentTurn = Reg.Turn.TWILIGHT;
                } else {
                    currentTurn = Reg.Turn.HANGING;
                }
            case Reg.Turn.HANGING:
                if (getSelectedCardNums() != 1) {
                    errorText.text = "Invalid number of character !";
                    Reg.hangingTarget = null;
                } else {
                    Reg.hangingTarget = getSelectedCard();
                    updateHangingState();
                    hangingIsDone = true;
                    summaryText.visible = true;
                    currentTurn = Reg.Turn.TWILIGHT;
                }
            case Reg.Turn.TWILIGHT:
                checkGameOver();
                if (hunterIsDead && !hunterFuneralIsDone) {
                    summaryText.visible = false;
                    currentTurn = Reg.Turn.FUNERAL;
                } else {
                    cleanUpState();
                    summaryText.text = "";
                    nightCount += 1;
                    currentTurn = Reg.Turn.DISABLER;
                }
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
                if (Reg.disablerTarget == Reg.characterMapping[Reg.Char.DETECTIVE]) {
                    guideText.text = "You're disabled !";
                } else {
                    guideText.text = "Pick 3 character to guess";
                }
            case Reg.Turn.SPELLCASTER:
                if (!Reg.characterMapping[Reg.Char.SPELLCASTER].isDead) {
                    guideText.text = "Pick a target to numb";
                    hideSpecificCards(Reg.Char.DISABLER);
                } else {
                    guideText.text = "Nothing to do !";
                }
            case Reg.Turn.SORCERER:
                if (Reg.portionLeft != 0 && !Reg.characterMapping[Reg.Char.SORCERER].isDead) {
                    guideText.text = "Optional: pick a portion, then pick a target\nPortion left: " + Reg.portionLeft;
                    if (toxicPortion.isSelected()) protectionPortion.clearSelect();
                    if (protectionPortion.isSelected()) toxicPortion.clearSelect();
                } else {
                    toxicPortion.visible = false;
                    protectionPortion.visible = false;
                    guideText.text = "Nothing to do !";
                }
            case Reg.Turn.WOLF:
                guideText.text = "Pick a target to attack";
                hideSpecificCards(Reg.Char.WOLF);
            case Reg.Turn.DISABLER:
                if (!Reg.characterMapping[Reg.Char.DISABLER].isDead) {
                    guideText.text = "Pick a character to disable";
                    hideSpecificCards(Reg.Char.DISABLER);
                } else {
                    guideText.text = "Nothing to do !";
                }
            case Reg.Turn.CURSED:
                guideText.text = "Nothing to do !";
            case Reg.Turn.HUNTER:
                guideText.text = "Nothing to do !";
            case Reg.Turn.APPRENTICE:
                if (Reg.characterMapping[Reg.Char.APPRENTICE] != null && !Reg.characterMapping[Reg.Char.APPRENTICE].isDead && !doneSelectMaster) {
                    guideText.text = "Pick a character to be your master";
                    hideSpecificCards(Reg.Char.APPRENTICE);
                } else {
                    guideText.text = "Nothing to do !";
                }
            case Reg.Turn.CUPID:
                if (!Reg.characterMapping[Reg.Char.CUPID].isDead) {
                    guideText.text = "Please select a couple";
                    if (doneSelectCouple) {
                        guideText.text = "Selected couple: " + Reg.couple[0].getName() + " & " + Reg.couple[1].getName();
                    }
                } else {
                    guideText.text = "Nothing to do !";
                }
            case Reg.Turn.MIDDAY:
                guideText.text = "Nothing to do !";
                hideAllCards();
            case Reg.Turn.DAWN:
                guideText.text = "Nothing to do !";
                hideAllCards();
            case Reg.Turn.FUNERAL:
                guideText.text = "Pick a target to follow hunter's dead";
            case Reg.Turn.HANGING:
                guideText.text = "Vote for a target to be hanged";
            case Reg.Turn.TWILIGHT:
                guideText.text = "Nothing to do !";
                hideAllCards();
            default:
        }
        setCurrentTurnText();
        super.update(elapsed);
    }

    function checkGameOver()
    {
        if (countAliveWolfs() >= countAliveVillagers()) {
            Reg.gameResult = Reg.Game.WOLFS_WON;
            FlxG.switchState(new GameOverState());
        } else if (countAliveWolfs() == 0) {
            Reg.gameResult = Reg.Game.VILLAGERS_WON;
            FlxG.switchState(new GameOverState());
        }
    }

    function countAliveWolfs():Int
    {
        var alive = 0;
        for (wolf in Reg.wolfs) {
            if (!wolf.isDead) alive += 1;
        }

        return alive;
    }

    function setTestState()
    {
        Reg.couple = [];
        Reg.couple.push(Reg.characterMapping[Reg.Char.CURSED]);
        Reg.couple.push(Reg.characterMapping[Reg.Char.HUNTER]);
        // Set disable
        Reg.disablerTarget = Reg.wolfs[0];
        // set wolf target
        Reg.wolfTarget = Reg.characterMapping[Reg.Char.CURSED];
        // Set protection
        Reg.portionLeft = 1;
        Reg.portionTarget = Reg.characterMapping[Reg.Char.SORCERER];
        Reg.portionUsed = Reg.Portion.PROTECTION;
        // Set spellcaster
        Reg.spellcasterTarget = Reg.characterMapping[Reg.Char.CUPID];
        // Set Apprentice
        doneSelectMaster = true;
        Reg.apprenticeTarget = Reg.characterMapping[Reg.Char.CUPID];
    }

    function isProtected(character:CharacterCard){
        return !Reg.characterMapping[Reg.Char.SORCERER].isDisabled && Reg.portionTarget == character && Reg.portionUsed == Reg.Portion.PROTECTION;
    }

    function isPoisoned(character:CharacterCard){
        return !Reg.characterMapping[Reg.Char.SORCERER].isDisabled && Reg.portionTarget == character && Reg.portionUsed == Reg.Portion.TOXIC;
    }

    function updateFuneralState()
    {
        var deadMans:Array<CharacterCard> = new Array();
        // check disable target
        summaryText.text += "\n--- Funeral Result ---\n\n";
        summaryText.text += "Hunter choose to kill " + Reg.hunterTarget.getFullName() + " !\n";
        pushIfNotExist(deadMans, Reg.hunterTarget);

        var lovedOne = getLover(Reg.hunterTarget);
        if (lovedOne != null){
            summaryText.text += lovedOne.getFullName() + " is in love with " + Reg.hunterTarget.getFullName() + ".\n";
            summaryText.text += lovedOne.getFullName() + " died of broken heart\n";
            pushIfNotExist(deadMans, lovedOne);
        }

        for (character in deadMans) {
            if (character == Reg.apprenticeTarget && !apprenticeUpgraded) {
                    summaryText.text += character.getFullName() + " is dead\n";
                    summaryText.text += Reg.characterMapping[Reg.Char.APPRENTICE].getFullName() + " became " + Reg.Names[character.type] + "\n";
                    apprenticeUpgraded = true;
                    upgradeApprentice(Reg.characterMapping[Reg.Char.APPRENTICE], Reg.apprenticeTarget);
            }
            summaryText.text += character.getFullName() + " is dead\n";
            character.setDead();
        }
        trace(deadMans);
        trace(summaryText.text);
    }

    function cleanUpState()
    {
        Reg.disablerTarget = null;
        Reg.apprenticeTarget = null;
        Reg.wolfTarget = null;
        Reg.portionUsed = null;
        Reg.portionTarget = null;
        Reg.spellcasterTarget = null;
        Reg.hunterTarget = null;
        Reg.hangingTarget = null;
        for (character in allCharacters) {
            if (!character.isDead) {
                character.isDisabled = false;
            }
        }
        summaryText.text = "";
        summaryText.visible = false;
    }

    function updateHangingState()
    {
        var deadMans:Array<CharacterCard> = new Array();
        // check disable target
        summaryText.text += "\n--- Vote Result ---\n\n";
        summaryText.text += "Everyone voted to hang " + Reg.hangingTarget.getFullName() + "\n";
        pushIfNotExist(deadMans, Reg.hangingTarget);

        var lovedOne = getLover(Reg.hangingTarget);
        if (lovedOne != null){
            summaryText.text += lovedOne.getFullName() + " is in love with " + Reg.hangingTarget.getFullName() + ".\n";
            summaryText.text += lovedOne.getFullName() + " died of broken heart\n";
            pushIfNotExist(deadMans, lovedOne);
        }

        for (character in deadMans) {
            if (character.type == Reg.Char.CURSED && !cursedUpgraded && Reg.wolfTarget == character) {
                cursedUpgraded = true;
                summaryText.text += character.getFullName() + " became wolf.\n";
                // TODO upgrade Wolf
                upgradeCursed(character);
            } else {
                summaryText.text += character.getFullName() + " is dead\n";
                if (character.type == Reg.Char.HUNTER && !hunterIsDead) {
                    hunterIsDead = true;
                }
                if (character.type == Reg.Char.WOLF) {
                    Reg.wolfs.remove(character);
                }
                if (character == Reg.apprenticeTarget && !apprenticeUpgraded) {
                    summaryText.text += character.getFullName() + " is dead\n";
                    summaryText.text += Reg.characterMapping[Reg.Char.APPRENTICE].getFullName() + " became " + Reg.Names[character.type] + "\n";
                    apprenticeUpgraded = true;
                    upgradeApprentice(Reg.characterMapping[Reg.Char.APPRENTICE], Reg.apprenticeTarget);
                }
                character.setDead();
            }
        }

        trace(deadMans);
        trace(summaryText.text);
    }

    function updateDawnState()
    {
        var deadMans:Array<CharacterCard> = new Array();
        // check disable target
        summaryText.text += "\n--- Result ---\n\n";
        if (Reg.disablerTarget != null) {
            Reg.disablerTarget.isDisabled = true;
            summaryText.text += Reg.characterMapping[Reg.Char.DISABLER].getFullName() + " slept with " + Reg.disablerTarget.getFullName() + "\n";
        }

        // first time disable cupid
        if (Reg.disablerTarget == Reg.characterMapping[Reg.Char.CUPID] && !doneSelectCouple) {
            doneSelectCouple = false;
            while (Reg.couple.length != 0) Reg.couple.pop();
        } else {
            doneSelectCouple = true;
        }

        if (countAliveWolfs() == 1 && Reg.disablerTarget.type == Reg.Char.WOLF) {
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
                if (isPoisoned(lovedOne)) {
                    summaryText.text += lovedOne.getFullName() + " is poisoned and died\n";
                }
                summaryText.text += lovedOne.getFullName() + " died of broken heart\n";
                pushIfNotExist(deadMans, lovedOne);
                break;
            }
        }

        for (character in deadMans) {
            if (character.type == Reg.Char.CURSED && !cursedUpgraded && Reg.wolfTarget == character) {
                cursedUpgraded = true;
                summaryText.text += character.getFullName() + " became wolf.\n";
                upgradeCursed(character);
            } else {
                summaryText.text += character.getFullName() + " is dead\n";
                if (character.type == Reg.Char.HUNTER && !hunterIsDead) {
                    hunterIsDead = true;
                }
                if (character.type == Reg.Char.WOLF) {
                    Reg.wolfs.remove(character);
                }
                if (character == Reg.apprenticeTarget && !apprenticeUpgraded) {
                    summaryText.text += Reg.characterMapping[Reg.Char.APPRENTICE].getFullName() + " became " + Reg.Names[character.type] + "\n";
                    apprenticeUpgraded = true;
                    upgradeApprentice(Reg.characterMapping[Reg.Char.APPRENTICE], Reg.apprenticeTarget);
                }
                character.setDead();
            }
        }

        if (Reg.spellcasterTarget != null && !Reg.characterMapping[Reg.Char.SPELLCASTER].isDisabled) {
            summaryText.text += Reg.spellcasterTarget.getFullName() + " is silenced\n";
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

    function upgradeCursed(cursed:CharacterCard)
    {
        cursed.type = Reg.Char.WOLF;
        cursed.setCharacterName(Reg.Names[cursed.type]);
        Reg.wolfs.push(cursed);
        Reg.characterMapping.remove(Reg.Char.CURSED);
    }

    function upgradeApprentice(apprentice:CharacterCard, master:CharacterCard)
    {
        // Upgrade apprentice
        Reg.characterMapping[master.type] = apprentice;
        apprentice.type = master.type;
        apprentice.setCharacterName(Reg.Names[master.type]);
        // Repick couple if master is Cupid
        if (master.type == Reg.Char.CUPID) {
            doneSelectCouple = false;
            while (Reg.couple.length != 0) Reg.couple.pop();
        }
        // Change to dead man
        Reg.characterMapping[Reg.Char.DEADMAN] = master;
        master.type = Reg.Char.DEADMAN;
        master.setCharacterName(Reg.Names[master.type]);
        Reg.characterMapping.remove(Reg.Char.APPRENTICE);
    }

    function getLover(character:CharacterCard){
        if (doneSelectCouple) {
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

    function countAliveVillagers():Int
    {
        var alive = 0;
        for (character in allCharacters) {
            if (character.type != Reg.Char.WOLF && !character.isDead) {
                alive += 1;
            }
        }

        return alive;
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
