package;

enum Char {
    WOLF;
    VILLAGER;
    CUPID;
    HUNTER;
    CURSED;
    DISABLER;
    NUMB_WITCH;
    SORCERER;
    APPRENTICE;
    DETECTIVE;
    DEADMAN;
}

enum Portion {
    TOXIC;
    PROTECTION;
}

enum Game {
    VILLAGERS_WON;
    WOLFS_WON;
    NEW;
}

enum Turn {
    WOLF;
    CUPID;
    HUNTER;
    CURSED;
    DISABLER;
    NUMB_WITCH;
    SORCERER;
    APPRENTICE;
    DETECTIVE;
    DAWN;
    FUNERAL;
    MIDDAY;
    HANGING;
    TWILIGHT;
}

class Reg
{
    public static var Characters:Array<Reg.Char>;
    public static var couple:Array<CharacterCard>;
    public static var Names = [
        Char.WOLF => "Wolf",
        Char.VILLAGER => "Villager",
        Char.CUPID => "Cupid",
        Char.HUNTER => "Hunter",
        Char.CURSED => "Cursed",
        Char.DISABLER => "Disabler",
        Char.NUMB_WITCH => "Numb Witch",
        Char.SORCERER => "Sorcerer",
        Char.APPRENTICE => "Apprentice",
        Char.DETECTIVE => "Detective",
        Char.DEADMAN => "Dead Man"
    ];

    public static var Images = [
        Char.WOLF => "wolf.png",
        Char.VILLAGER => "villager.png",
        Char.CUPID => "cupid.png",
        Char.HUNTER => "hunter.png",
        Char.CURSED => "cursed.png",
        Char.DISABLER => "disabler.png",
        Char.NUMB_WITCH => "witch.png",
        Char.SORCERER => "sorcerer.png",
        Char.APPRENTICE => "apprentice.png",
        Char.DETECTIVE => "detective.png"
    ];

    public static var TurnNames = [
        Turn.WOLF => "Wolf",
        Turn.CUPID => "Cupid",
        Turn.HUNTER => "Hunter",
        Turn.CURSED => "Cursed",
        Turn.DISABLER => "Disabler",
        Turn.NUMB_WITCH => "Numb Witch",
        Turn.SORCERER => "Sorcerer",
        Turn.APPRENTICE => "Apprentice",
        Turn.DETECTIVE => "Detective",
        Turn.DAWN => "The Dawn",
        Turn.FUNERAL => "The Hunter's Funeral",
        Turn.MIDDAY => "The Midday",
        Turn.HANGING => "The Hanging Man",
        Turn.TWILIGHT => "The Twilight"
    ];

    public static var playerNames:Array<String>;
    public static var disablerTarget:CharacterCard = null;
    public static var apprenticeTarget:CharacterCard = null;
    public static var wolfTarget:CharacterCard = null;
    public static var portionLeft = 2;
    public static var portionUsed:Reg.Portion;
    public static var portionTarget:CharacterCard = null;
    public static var numbWitchTarget:CharacterCard = null;
    public static var hunterTarget:CharacterCard = null;
    public static var hangingTarget:CharacterCard = null;
    public static var characterMapping:Map<Reg.Char, CharacterCard>;
    public static var wolfs:Array<CharacterCard>;
    public static var gameResult:Reg.Game = Reg.Game.NEW;
}