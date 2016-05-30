package ;
import flixel.FlxG;
import flash.display3D.textures.RectangleTexture;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

class PortionCard extends FlxSprite
{
    var cardFrame:FlxSprite;
    public var type:Reg.Portion;

    public function new(X:Float, Y:Float, type:Reg.Portion)
    {
        super(X, Y);
        this.type = type;
        var image = "";
        if (isToxic()) {
            image = "toxic_portion.png";
        } else {
            image = "protection_portion.png";
        }
        loadGraphic("assets/images/" + image, true, 87, 42);
        animation.add("toggle", [0, 1], 0, false);
        animation.frameIndex = 1;
        FlxMouseEventManager.add(this, onMouseDown, onMouseUp, onMouseOver, onMouseOut);
    }

    public function isToxic():Bool
    {
        return this.type == Reg.Portion.TOXIC;
    }

    public function isProtection():Bool
    {
        return this.type == Reg.Portion.PROTECTION;
    }

    public function isSelected(){
        return animation.frameIndex == 0;
    }

    public function clearSelect()
    {
        animation.frameIndex = 1;
    }

    public function setSelect()
    {
        animation.frameIndex = 0;
    }

    function onMouseDown(sprite:FlxSprite) {}
    function onMouseUp(sprite:FlxSprite) {
        animation.frameIndex = (animation.frameIndex + 1) % 2;
    }
    function onMouseOver(sprite:FlxSprite) {}
    function onMouseOut(sprite:FlxSprite) {}

    override public function update(elapsed:Float):Void
    {
        #if mobile
        for (touch in FlxG.touches.list) {
            if (touch.justPressed && touch.overlaps(cardFrame)) {
                animation.frameIndex = (animation.frameIndex + 1) % 2;
            }
        }
        #end
        super.update(elapsed);
    }
}