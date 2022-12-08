package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.math.Vector2;
import haxepunk.math.Random;
import haxepunk.math.MathUtil;
import haxepunk.graphics.Image;

class Enzyme extends Entity
{

	public function new()
	{
        var pos = new Vector2();
		MathUtil.angleXY(pos,
                Random.randInt(360),
                Random.randInt(100) + 50,
                HXP.halfWidth, HXP.halfHeight);
		super(pos.x, pos.y);
		image = new Image("graphics/enzyme.png");
		image.color = HXP.choose(Enzyme.colors);
        image.centerOrigin();
		graphic = image;

		setHitboxTo(graphic);
		type = "enzyme";

		life = Random.randInt(10) + 10;
	}

	public override function update()
	{
		life -= HXP.elapsed;
		if (life < 0)
		{
            scene.may(s -> {
                s.remove(this);
            });
            life = 0;
		}

        image.angle += 1;
		super.update();
	}

	public static var colors:Array<Int> = [0xFFFFFF];

	private var life:Float;
	public var image:Image;

}
