package worlds;

import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.graphics.Text;
import com.haxepunk.utils.Input;

class InstructionWorld extends World
{

	public function new()
	{
		super();

		addGraphic(new Image("gfx/overlay.png"));
		var colors = [0xFFFFFF, 0x55FFFF, 0xFFFF55, 0xFF55FF];

		centeredText("Move with the arrow keys", -180);

		var x = -30;
		for (i in 0...colors.length)
		{
			addEnzyme(x, colors[i]);
			x += 20;
		}
		centeredText("Digest enzymes to change colors", -75);

		var x = -60;
		for (i in 0...colors.length)
		{
			addGerm(x, colors[i]);
			x += 40;
		}
		centeredText("Kill germs by matching your color", 75);

		centeredText("Protect the cell in the center from germs", 0);

		centeredText("Click to Start", 180);
	}

	private function addEnzyme(x:Int, color:Int)
	{
		var enzyme = new Image("gfx/enzyme.png");
		enzyme.color = color;
		addGraphic(enzyme, 10, HXP.halfWidth + x, HXP.halfHeight - 100);
	}

	private function addGerm(x:Int, color:Int)
	{
		var germ = new Spritemap("gfx/germ.png", 16, 16);
		germ.add("idle", [0, 1, 2], 6);
		germ.play("idle");
		germ.color = color;
		addGraphic(germ, 10, HXP.halfWidth + x, HXP.halfHeight + 100);
	}

	private function centeredText(text:String, y:Int)
	{
		var image = new Text(text);
		image.centerOO();
		addGraphic(image, 0, Std.int(HXP.halfWidth), Std.int(HXP.halfHeight) + y);
	}

	public override function update()
	{
		if (Input.mousePressed)
		{
			HXP.world = new GameWorld();
		}
		super.update();
	}

}