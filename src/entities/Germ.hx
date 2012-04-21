package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;

class Germ extends Entity
{

	public function new()
	{
		super(0, 0);
		sprite = new Spritemap("gfx/germ.png", 16, 16);
		var frames = [0, 1, 2];
		HXP.shuffle(frames);
		sprite.add("move", frames, 8);
		sprite.play("move");
		sprite.centerOO();
		sprite.color = HXP.choose(Enzyme.colors);
		graphic = sprite;

		setHitbox(16, 16, 8, 8);
		type = "germ";
	}

	public override function update()
	{
		moveTowards(HXP.halfWidth, HXP.halfHeight, HXP.random * 0.5);
		sprite.angle += HXP.random * 3 - 1;
		super.update();
	}

	public var sprite:Spritemap;

}