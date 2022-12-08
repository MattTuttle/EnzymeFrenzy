package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.math.Random;
import haxepunk.math.Vector2;
import haxepunk.math.MathUtil;
import haxepunk.graphics.Spritemap;

class Germ extends Entity
{

	public function new()
	{
        var pos = new Vector2();
		MathUtil.angleXY(pos,
                Random.randInt(360), 250,
                HXP.halfWidth, HXP.halfHeight);
		super(pos.x, pos.y);
		sprite = new Spritemap("graphics/germ.png", 16, 16);
		var frames = [0, 1, 2];
		HXP.shuffle(frames);
		sprite.add("move", frames, 8);
		sprite.play("move");
		sprite.centerOrigin();
		sprite.color = HXP.choose(Enzyme.colors);
		graphic = sprite;

		setHitbox(16, 16, 8, 8);
		type = "germ";
	}

	public override function update()
	{
		moveTowards(HXP.halfWidth, HXP.halfHeight, Random.random * 0.5);
		sprite.angle += Random.random * 3 - 1;
		super.update();
	}

	public var sprite:Spritemap;

}
