package worlds;

import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.Tween;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.misc.Alarm;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import entities.MotherCell;
import entities.WhiteBloodCell;
import entities.Germ;
import entities.Enzyme;

class GameWorld extends World
{

	public function new()
	{
		super();
		enzymeTimer = new Alarm(1, spawnEnzyme, TweenType.Persist);
		germTimer = new Alarm(2, spawnGerm, TweenType.Persist);
		addTween(enzymeTimer);
		addTween(germTimer);
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
		addGraphic(new Image("gfx/overlay.png")).layer = 5;
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
		HXP.angleXY(enzyme, HXP.rand(360), HXP.rand(100) + 50, HXP.halfWidth, HXP.halfHeight);
		add(enzyme);
		if (gameover == false)
		{
			enzymeTimer.reset(HXP.random * 5);
		}
	}

	private function spawnGerm()
	{
		// TODO: check if an enzyme of matching color is currently on the screen
		var germ = new Germ();
		HXP.angleXY(germ, HXP.rand(360), 250, HXP.halfWidth, HXP.halfHeight);
		add(germ);

		if (gameover == false)
		{
			germTimer.reset(HXP.random * 3);
		}
	}

	public override function update()
	{
		if (player.dead || mother.dead)
		{
			if (Input.mousePressed)
			{
				HXP.world = new MainWorld();
			}
			// only do this once on game over
			if (gameover == false)
			{
				mother.kill();
				player.kill();

				var text = new Text("Game Over", HXP.halfWidth, HXP.halfHeight);
				text.centerOO();
				addGraphic(text).layer = 0;

				text = new Text("Click to continue", HXP.halfWidth, HXP.halfHeight + 40);
				text.centerOO();
				addGraphic(text).layer = 0;
			}
			gameover = true;
		}

		super.update();
	}

	private var gameover:Bool;
	private var player:WhiteBloodCell;
	private var mother:MotherCell;
	private var enzymeCount:Int;
	private var enzymeTimer:Alarm;
	private var germTimer:Alarm;

}