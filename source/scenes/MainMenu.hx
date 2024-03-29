package scenes;

import haxepunk.Entity;
import haxepunk.HXP;
import haxepunk.math.Random;
import haxepunk.Tween;
import haxepunk.Scene;
import haxepunk.graphics.Image;
import haxepunk.graphics.Spritemap;
import haxepunk.graphics.text.Text;
import haxepunk.tweens.sound.Fader;
import haxepunk.input.Mouse;

class MainMenu extends Scene
{

	public function new()
	{
		super();

		var fader = new Fader(TweenType.OneShot);
		fader.fadeTo(1, 1);
		addTween(fader, true);
	}

	public override function begin()
	{
		var image = new Image("graphics/title.png");
		image.centerOrigin();
		title = addGraphic(image, 5, HXP.halfWidth, HXP.halfHeight);

		addGraphic(new Image("graphics/overlay.png"));

		image = new Text("Click to Start");
		image.centerOrigin();
		addGraphic(image, 0, HXP.halfWidth, HXP.halfHeight + 180);

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
		var germ = new Spritemap("graphics/germ.png", 16, 16);
		germ.add("idle", [0, 1, 2], 6);
		germ.play("idle");
		germ.color = color;
		addGraphic(germ, 15, Random.randInt(HXP.width), Random.randInt(HXP.height));
	}

	private function addEnzyme(color:Int)
	{
		var enzyme = new Image("graphics/enzyme.png");
		enzyme.color = color;
		addGraphic(enzyme, 15, Random.randInt(HXP.width), Random.randInt(HXP.height));
	}

	public override function update()
	{
		title.x += Random.random - 0.5;
		title.y += Random.random - 0.5;

		if (Mouse.mousePressed && fader == null)
		{
			fader = new Fader(TweenType.OneShot);
			fader.onComplete.bind(function() {
				HXP.scene = new Instruction();
			});
			fader.fadeTo(0, 1);
			addTween(fader, true);
		}
		super.update();
	}

	private var title:Entity;
	private var fader:Fader;

}
