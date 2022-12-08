package scenes;

import haxepunk.HXP;
import haxepunk.Tween;
import haxepunk.Scene;
import haxepunk.math.Random;
import haxepunk.math.MathUtil;
import haxepunk.graphics.Image;
import haxepunk.graphics.text.Text;
import haxepunk.tweens.misc.Alarm;
import haxepunk.input.Mouse;
import entities.MotherCell;
import entities.WhiteBloodCell;
import entities.Germ;
import entities.Enzyme;

class Game extends Scene
{

	public function new()
	{
		super();
		enzymeTimer = new Alarm(1, spawnEnzyme, TweenType.Persist);
		germTimer = new Alarm(2, spawnGerm, TweenType.Persist);
		addTween(enzymeTimer, true);
		addTween(germTimer, true);
		enzymeCount = 0;
		HXP.volume = 1;
	}

	public override function begin()
	{
		mother = new MotherCell();
		add(mother);

		player = new WhiteBloodCell(HXP.halfWidth, HXP.halfHeight + 50);
		add(player);

		enzymeTimer.start();
		germTimer.start();

		addGraphic(new Image("graphics/overlay.png")).layer = -5;
	}

	private function spawnEnzyme()
	{
		// increase difficulty
		enzymeCount += 1;
		switch (enzymeCount)
		{
			case 1:
				Enzyme.colors = [0xFFFFFF];
			case 5:
				Enzyme.colors.push(0x55FFFF);
			case 20:
				Enzyme.colors.push(0xFFFF55);
			case 60:
				Enzyme.colors.push(0xFF55FF);
			case 150:
				Enzyme.colors.push(0x55FF55);
			case 300:
				Enzyme.colors.push(0xFF5555);
		}

		var enzyme = new Enzyme();
		add(enzyme);
		if (gameover == false)
		{
			enzymeTimer.reset(Random.random * 5);
		}
	}

	private function spawnGerm()
	{
		// TODO: check if an enzyme of matching color is currently on the screen
		add(new Germ());

		if (gameover == false)
		{
			germTimer.reset(Random.random * 3 + 1);
		}
	}

	public override function update()
	{
		if (player.dead || mother.dead)
		{
			if (Mouse.mousePressed)
			{
				HXP.scene = new MainMenu();
			}
			// only do this once on game over
			if (gameover == false)
			{
				mother.kill();
				player.kill();

				var text = new Text("Game Over");
				text.centerOrigin();
				addGraphic(text).layer = 0;

				text = new Text("Click to continue", HXP.halfWidth, HXP.halfHeight + 40);
				text.centerOrigin();
				addGraphic(text).layer = 0;
			}
            gameover = true;
        }

		super.update();
	}

	private var gameover:Bool = false;
	private var player:WhiteBloodCell;
	private var mother:MotherCell;
	private var enzymeCount:Int;
	private var enzymeTimer:Alarm;
	private var germTimer:Alarm;

}
