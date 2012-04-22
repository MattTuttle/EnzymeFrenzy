package worlds;

import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import com.haxepunk.Tween;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.tweens.sound.Fader;
import com.haxepunk.utils.Input;

class MainWorld extends World
{

	public function new()
	{
		super();

		// don't layer the music...
		if (music == null)
		{
			music = new Sfx("music/background");
		}
		music.loop(1, 0);
		var fader = new Fader(null, TweenType.OneShot);
		fader.fadeTo(1, 1);
		addTween(fader);
		fading = false;
	}

	public override function begin()
	{
		var image = new Image("gfx/title.png");
		image.centerOO();
		title = addGraphic(image, 5, Std.int(HXP.halfWidth), Std.int(HXP.halfHeight));

		addGraphic(new Image("gfx/overlay.png"));

		image = new Text("Click to Start");
		image.centerOO();
		addGraphic(image, 0, Std.int(HXP.halfWidth), Std.int(HXP.halfHeight) + 180);

		var colors = [0xFFFFFF, 0xFFFF55, 0xFF55FF, 0x55FF55];

		for (i in 0...20)
		{
			addEnzyme(HXP.choose(colors));
		}

		for (i in 0...10)
		{
			addGerm(HXP.choose(colors));
		}
	}

	private function addGerm(color:Int)
	{
		var germ = new Spritemap("gfx/germ.png", 16, 16);
		germ.add("idle", [0, 1, 2], 6);
		germ.play("idle");
		germ.color = color;
		addGraphic(germ, 15, HXP.rand(HXP.width), HXP.rand(HXP.height));
	}

	private function addEnzyme(color:Int)
	{
		var enzyme = new Image("gfx/enzyme.png");
		enzyme.color = color;
		addGraphic(enzyme, 15, HXP.rand(HXP.width), HXP.rand(HXP.height));
	}

	public override function update()
	{
		title.x += HXP.random - 0.5;
		title.y += HXP.random - 0.5;

		if (Input.mousePressed && ! fading)
		{
			fading = true;
			var fader = new Fader(function() {
					HXP.world = new InstructionWorld();
					music.stop();
				}, TweenType.OneShot);
			fader.fadeTo(0, 1);
			addTween(fader);
		}
		super.update();
	}

	private static var music:Sfx;
	private var title:Entity;
	private var fading:Bool;

}