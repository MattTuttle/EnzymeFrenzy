package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.math.Random;
import haxepunk.graphics.Image;

class Enzyme extends Entity
{

	public function new()
	{
		super(0, 0);
		image = new Image("gfx/enzyme.png");
		image.color = HXP.choose(Enzyme.colors);
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
			scene.remove(this);
		}

		x += Random.random - 0.5;
		y += Random.random - 0.5;
		super.update();
	}

	public static var colors:Array<Int> = [0xFFFFFF];

	private var life:Float;
	public var image:Image;

}
