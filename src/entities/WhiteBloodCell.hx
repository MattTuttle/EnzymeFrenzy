package entities;

import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.masks.Circle;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

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
		world.addGraphic(scoreText).layer = 0;
		score = 0;
	}

	private inline function handleInput()
	{
		acceleration.x = gravity.x;
		acceleration.y = gravity.y;

		if (Input.check(Key.LEFT))
		{
			acceleration.x = -MOVE_SPEED;
		}
		if (Input.check(Key.RIGHT))
		{
			acceleration.x = MOVE_SPEED;
		}
		if (Input.check(Key.UP))
		{
			acceleration.y = -MOVE_SPEED;
		}
		if (Input.check(Key.DOWN))
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
		if (Math.abs(velocity.x) > maxVelocity.x) velocity.x = maxVelocity.x * HXP.sign(velocity.x);

		velocity.x += DRAG * (velocity.x > 0 ? -1 : 1);
		if (Math.abs(velocity.x) < 0.5) velocity.x = 0;


		velocity.y += acceleration.y;
		if (Math.abs(velocity.y) > maxVelocity.y) velocity.y = maxVelocity.y * HXP.sign(velocity.y);

		velocity.y += DRAG * (velocity.y > 0 ? -1 : 1);
		if (Math.abs(velocity.y) < 0.5) velocity.y = 0;

		// move and collide with entities
		moveBy(velocity.x, velocity.y, ["germ", "enzyme", "mother"]);

		// rotate to angle
		if (velocity.x != 0 || velocity.y != 0)
		{
			sprite.angle = Math.atan2(velocity.y, velocity.x) * HXP.DEG;
			if (sprite.angle < 0) sprite.angle += 360;
		}

		// clamp in microscope circle
		if (HXP.distance(HXP.halfWidth, HXP.halfHeight, x, y) > 160) {
			var angle = HXP.angle(HXP.halfWidth, HXP.halfHeight, x, y);
			HXP.angleXY(this, angle, 160, HXP.halfWidth, HXP.halfHeight);
		}
	}

	private function collideGerm(e:Entity)
	{
		var germ:Germ = cast(e, Germ);
		if (germ.sprite.color == sprite.color)
		{
			new Sfx("sfx/slurp").play(0.3);
			world.remove(germ);
		}
		else
		{
			new Sfx("sfx/explode").play(0.2);
			kill();
		}
		score += 3;
	}

	private function collideEnzyme(e:Entity)
	{
		var enzyme:Enzyme = cast(e, Enzyme);
		sprite.color = enzyme.image.color;
		world.remove(enzyme);
		score += 1;
		new Sfx("sfx/pickup").play(0.3);
	}

	private inline function collideEntity(e:Entity)
	{
		switch (e.type)
		{
			case "enzyme":
				collideEnzyme(e);
			case "germ":
				collideGerm(e);
		}
	}

	public override function moveCollideX(e:Entity)
	{
		collideEntity(e);
	}

	public override function moveCollideY(e:Entity)
	{
		collideEntity(e);
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
		if (world != null)
		{
			world.remove(this);
		}
		health = 0;
	}

	public var dead(getDead, never):Bool;
	private function getDead():Bool
	{
		return health <= 0;
	}

	private var acceleration:Point;
	private var velocity:Point;
	private var gravity:Point;
	private var maxVelocity:Point;

	private var scoreText:Text;
	private var score(default, setScore):Int;
	private function setScore(value:Int):Int {
		score = value;
		scoreText.text = "Score: " + score;
		return value;
	}

	private static inline var DRAG:Float = 0.3;
	private static inline var MOVE_SPEED:Float = 0.8;

	private var health:Int;
	private var sprite:Spritemap;

}