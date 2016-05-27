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
}

class Reg
{
	public static var Characters:Array<Reg.Char>;
	public static var Couple:Array<CharacterCard>;
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
		Turn.DETECTIVE => "Detective"
	];

	public static var PlayerNames:Array<String>;
    public static var disablerTarget:CharacterCard = null;
}