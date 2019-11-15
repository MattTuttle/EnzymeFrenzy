package entities;

import flash.geom.Point;
import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.Sfx;
import haxepunk.math.MathUtil;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.text.Text;
import haxepunk.masks.Circle;
import haxepunk.input.Key;

class WhiteBloodCell extends Entity
{

	public function new(x:Float, y:Float)
	{
		super(x, y);

		sprite = new Spritemap("gfx/cell.png", 16, 16);
		sprite.add("idle", [0]);
		sprite.add("move", [0, 1, 2], 16);
		sprite.centerOO();
		graphic = sprite;
		mask = new Circle(8, -8, -8);

		health = 1;

		acceleration = new Point();
		velocity = new Point();
		gravity = new Point();
		maxVelocity = new Point(5, 5);
	}

	public override function added()
	{
		scoreText = new Text("Score: 0", 20, 20, 100, 20);
		scene.addGraphic(scoreText).layer = 0;
		score = 0;
	}

	private inline function handleInput()
	{
		acceleration.x = gravity.x;
		acceleration.y = gravity.y;

		if (Key.check(Key.LEFT))
		{
			acceleration.x = -MOVE_SPEED;
		}
		if (Key.check(Key.RIGHT))
		{
			acceleration.x = MOVE_SPEED;
		}
		if (Key.check(Key.UP))
		{
			acceleration.y = -MOVE_SPEED;
		}
		if (Key.check(Key.DOWN))
		{
			acceleration.y = MOVE_SPEED;
		}
	}

	private inline function handleAnimation()
	{
		if (velocity.x == 0 && velocity.y == 0)
		{
			sprite.play("idle");
		}
		else
		{
			sprite.play("move");
		}
	}

	private inline function handleMovement()
	{
		velocity.x += acceleration.x;
		if (Math.abs(velocity.x) > maxVelocity.x) velocity.x = maxVelocity.x * MathUtil.sign(velocity.x);

		velocity.x += DRAG * (velocity.x > 0 ? -1 : 1);
		if (Math.abs(velocity.x) < 0.5) velocity.x = 0;


		velocity.y += acceleration.y;
		if (Math.abs(velocity.y) > maxVelocity.y) velocity.y = maxVelocity.y * MathUtil.sign(velocity.y);

		velocity.y += DRAG * (velocity.y > 0 ? -1 : 1);
		if (Math.abs(velocity.y) < 0.5) velocity.y = 0;

		// move and collide with entities
		moveBy(velocity.x, velocity.y, ["germ", "enzyme", "mother"]);

		// rotate to angle
		if (velocity.x != 0 || velocity.y != 0)
		{
			sprite.angle = Math.atan2(velocity.y, velocity.x) * MathUtil.DEG;
			if (sprite.angle < 0) sprite.angle += 360;
		}

		// clamp in microscope circle
		if (MathUtil.distance(HXP.halfWidth, HXP.halfHeight, x, y) > 160) {
			var angle = MathUtil.angle(HXP.halfWidth, HXP.halfHeight, x, y);
			MathUtil.angleXY(this, angle, 160, HXP.halfWidth, HXP.halfHeight);
		}
	}

	private function collideGerm(e:Entity):Bool
	{
		var germ:Germ = cast(e, Germ);
		if (germ.sprite.color == sprite.color)
		{
			new Sfx("sfx/slurp").play(0.3);
			scene.remove(germ);
		}
		else
		{
			new Sfx("sfx/explode").play(0.2);
			kill();
		}
		score += 3;
		return true;
	}

	private function collideEnzyme(e:Entity):Bool
	{
		var enzyme:Enzyme = cast(e, Enzyme);
		sprite.color = enzyme.image.color;
		scene.remove(enzyme);
		score += 1;
		new Sfx("sfx/pickup").play(0.3);
		return true;
	}

	private inline function collideEntity(e:Entity):Bool
	{
		return switch (e.type)
		{
			case "enzyme":
				collideEnzyme(e);
			case "germ":
				collideGerm(e);
			default:
				false;
		}
	}

	public override function moveCollideX(e:Entity):Bool
	{
		return collideEntity(e);
	}

	public override function moveCollideY(e:Entity):Bool
	{
		return collideEntity(e);
	}

	public override function update()
	{
		if (dead) return;

		handleInput();
		handleMovement();
		handleAnimation();

		super.update();
	}

	public function kill()
	{
		if (dead) return;
		if (scene != null)
		{
			scene.remove(this);
		}
		health = 0;
	}

	public var dead(get_dead, never):Bool;
	private function get_dead():Bool
	{
		return health <= 0;
	}

	private var acceleration:Point;
	private var velocity:Point;
	private var gravity:Point;
	private var maxVelocity:Point;

	private var scoreText:Text;
	private var score(default, set_score):Int;
	private function set_score(value:Int):Int {
		score = value;
		scoreText.text = "Score: " + score;
		return value;
	}

	private static inline var DRAG:Float = 0.3;
	private static inline var MOVE_SPEED:Float = 0.8;

	private var health:Int;
	private var sprite:Spritemap;

}
