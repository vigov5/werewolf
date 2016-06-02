package;

enum Char {
    WOLF;
    VILLAGER;
    CUPID;
    HUNTER;
    CURSED;
    DISABLER;
    DUMB_WITCH;
    SORCERER;
    APPRENTICE;
    DETECTIVE;
}

enum Portion {
    TOXIC;
    PROTECTION;
}

enum Turn {
    WOLF;
    CUPID;
    HUNTER;
    CURSED;
    DISABLER;
    DUMB_WITCH;
    SORCERER;
    APPRENTICE;
    DETECTIVE;
    DAWN;
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
        Char.DUMB_WITCH => "Dumb Witch",
        Char.SORCERER => "Sorcerer",
        Char.APPRENTICE => "Apprentice",
        Char.DETECTIVE => "Detective"
    ];

    public static var Images = [
        Char.WOLF => "wolf.png",
        Char.VILLAGER => "villager.png",
        Char.CUPID => "cupid.png",
        Char.HUNTER => "hunter.png",
        Char.CURSED => "cursed.png",
        Char.DISABLER => "disabler.png",
        Char.DUMB_WITCH => "witch.png",
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
        Turn.DUMB_WITCH => "Dumb Witch",
        Turn.SORCERER => "Sorcerer",
        Turn.APPRENTICE => "Apprentice",
        Turn.DETECTIVE => "Detective",
        Turn.DAWN => "The Dawn",
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
    public static var dumbWitchTarget:CharacterCard = null;
    public static var characterMapping:Map<Reg.Char, CharacterCard>;
    public static var wolfs:Array<CharacterCard>;
}