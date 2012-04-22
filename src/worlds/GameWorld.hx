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

		// don't layer the music...
		if (music == null)
		{
			music = new Sfx("music/background");
			music.loop(1, 0);
		}
	}

	public override function begin()
	{
		player = new WhiteBloodCell(HXP.halfWidth, HXP.halfHeight);
		add(player);

		enzymeTimer.start();
		germTimer.start();
		addGraphic(new Image("gfx/overlay.png")).layer = 5;
	}

	private function spawnEnzyme()
	{
		var enzyme = new Enzyme();
		HXP.angleXY(enzyme, HXP.rand(360), HXP.rand(150), HXP.halfWidth, HXP.halfHeight);
		add(enzyme);
		enzymeTimer.reset(HXP.random * 5);

		// increase difficulty
		enzymeCount += 1;
		switch (enzymeCount)
		{
			case 5:
				Enzyme.colors.push(0xAAFFFF);
			case 20:
				Enzyme.colors.push(0xFFFFAA);
			case 60:
				Enzyme.colors.push(0xFFAAFF);
		}
	}

	private function spawnGerm()
	{
		// TODO: check if an enzyme of matching color is currently on the screen
		var germ = new Germ();
		HXP.angleXY(germ, HXP.rand(360), 250, HXP.halfWidth, HXP.halfHeight);
		add(germ);
		germTimer.reset(HXP.random * 3);
	}

	public override function update()
	{
		if (player.dead)
		{
			if (Input.check(Key.SPACE))
			{
				HXP.world = new GameWorld();
			}
			// only do this once on game over
			if (gameover == false)
			{
				var text = new Text("Game Over", HXP.halfWidth, HXP.halfHeight);
				text.centerOO();
				addGraphic(text).layer = 0;

				text = new Text("Press Space to Restart", HXP.halfWidth, HXP.halfHeight + 40);
				text.centerOO();
				addGraphic(text).layer = 0;
			}
			gameover = true;
		}
		super.update();
	}

	private static var music:Sfx;
	private var gameover:Bool;
	private var player:WhiteBloodCell;
	private var enzymeCount:Int;
	private var enzymeTimer:Alarm;
	private var germTimer:Alarm;

}