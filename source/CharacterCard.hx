package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

class CharacterCard extends FlxSpriteGroup
{
    var cardFrame:FlxSprite;
    var cardImage:FlxSprite;
    var cardName:FlxText;
    var playerName:FlxText;
    public var type:Reg.Char;
    public var isDisabled = false;
    public var isDead = false;

    public function new(X:Float, Y:Float, type:Reg.Char)
    {
        super(X, Y);
        this.type = type;
        cardFrame = new FlxSprite();
        cardFrame.loadGraphic("assets/images/frame.png", true, 77, 107);
        cardFrame.animation.add("toggle", [0, 1, 2], 0, false);
        cardFrame.animation.frameIndex = 1;
        add(cardFrame);
        cardImage = new FlxSprite();
        cardImage.loadGraphic("assets/images/" + Reg.Images[type]);
        cardImage.setPosition((cardFrame.frameWidth - cardImage.width) / 2, cardFrame.frameHeight - cardImage.height - 28);
        add(cardImage);
        cardName = new FlxText(0, 80, 77);
        cardName.text = Reg.Names[type];
        cardName.setFormat(null, 8, 0x37322E, CENTER);
        add(cardName);
        playerName = new FlxText(0, 90, 77);
        playerName.text = "";
        playerName.setFormat(null, 8, 0x000000, CENTER);
        add(playerName);
        FlxMouseEventManager.add(cardFrame, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
    }

    public function setPlayerName(name:String)
    {
        playerName.text = name;
    }

    public function setCharacterName(name:String)
    {
        cardName.text = name;
    }

    public function getFullName():String
    {
        return playerName.text + " (" + Reg.Names[type] + ")";
    }

    public function getName(){
        return playerName.text;
    }

    public function hide(){
        cardFrame.visible = false;
        cardImage.visible = false;
        cardName.visible = false;
        playerName.visible = false;
    }

    public function show(){
        cardFrame.visible = true;
        cardImage.visible = true;
        cardName.visible = true;
        playerName.visible = true;
    }
     
    public function isSelected(){
        return cardFrame.animation.frameIndex == 0;
    }

    public function clearSelect()
    {
        cardFrame.animation.frameIndex = 1;
    }

    public function setDead()
    {
        isDead = true;
        isDisabled = true;
        cardFrame.animation.frameIndex = 2;
    }
    
    function onMouseDown(sprite:FlxSprite) {}
    function onMouseUp(sprite:FlxSprite) {
        if (!isDead) {
            cardFrame.animation.frameIndex = (cardFrame.animation.frameIndex + 1) % 2;
        }
    }
    function onMouseOver(sprite:FlxSprite) {}
    function onMouseOut(sprite:FlxSprite) {}

    override public function update(elapsed:Float):Void
    {
        if (!isDead) {
            #if mobile
            for (touch in FlxG.touches.list) {
                if (touch.justPressed && touch.overlaps(cardFrame)) {
                    cardFrame.animation.frameIndex = (cardFrame.animation.frameIndex + 1) % 2;
                }
            }
            #end
        } else {
            cardFrame.animation.frameIndex = 2;
        }
        super.update(elapsed);
    }
}