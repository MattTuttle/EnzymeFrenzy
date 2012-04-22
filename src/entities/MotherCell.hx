package entities;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.masks.Circle;

class MotherCell extends Entity
{

	public function new()
	{
		super(HXP.halfWidth, HXP.halfHeight);
		image = new Spritemap("gfx/mother.png", 32, 32);
		image.centerOO();
		graphic = image;
		mask = new Circle(16, -16, -16);
		health = 10;
		type = "mother";
	}

	public override function update()
	{
		if (dead) return;
		var e:Entity = collide("germ", x, y);
		image.scale = HXP.random * 0.1 + 0.9;
		image.angle += HXP.random * 3 - 1;
		if (e != null)
		{
			new Sfx("sfx/hit").play(0.3);
			health -= 1;
			image.setFrame(10 - health);
			world.remove(e);
			if (health <= 0)
			{
				kill();
			}
		}
		super.update();
	}

	public function kill()
	{
		if (world != null)
		{
			new Sfx("sfx/explosion").play(0.3);
			world.remove(this);
		}
		health = 0;
	}

	public var dead(getDead, never):Bool;
	private function getDead():Bool
	{
		return health <= 0;
	}

	private var health:Int;
	private var image:Spritemap;

}