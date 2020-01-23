package entities;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.Sfx;
import haxepunk.assets.AssetCache;
import haxepunk.math.Random;
import haxepunk.graphics.Spritemap;
import haxepunk.masks.Circle;

class MotherCell extends Entity
{

	public function new()
	{
		super(HXP.halfWidth, HXP.halfHeight);
		image = new Spritemap("assets/graphics/mother.png", 32, 32);
		image.centerOrigin();
		graphic = image;
		mask = new Circle(16, -16, -16);
		health = 10;
		type = "mother";
	}

	public override function update()
	{
		if (dead) return;
		var e:Entity = collide("germ", x, y);
		image.scale = Random.random * 0.1 + 0.9;
		image.angle += Random.random * 3 - 1;
		if (e != null)
		{
			new Sfx("assets/sfx/hit.mp3").play(0.3);
			health -= 1;
			image.frame = 10 - health;
			scene.remove(e);
			if (health <= 0)
			{
				kill();
			}
		}
		super.update();
	}

	public function kill()
	{
		if (scene != null)
		{
			new Sfx("assets/sfx/explosion.mp3").play(0.3);
			scene.remove(this);
		}
		health = 0;
	}

	public var dead(get, never):Bool;
	private function get_dead():Bool
	{
		return health <= 0;
	}

	private var health:Int;
	private var image:Spritemap;

}
