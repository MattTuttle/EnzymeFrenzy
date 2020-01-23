import haxepunk.debug.Console;
import haxepunk.Engine;
import haxepunk.HXP;
import worlds.MainWorld;

class Main extends Engine
{

	public static inline var kScreenWidth:Int = 400;
	public static inline var kScreenHeight:Int = 400;
	public static inline var kFrameRate:Int = 30;
	public static inline var kClearColor:Int = 0x302B30;
	public static inline var kProjectName:String = "HaxePunk";

	public function new()
	{
		super(kScreenWidth, kScreenHeight, kFrameRate, false);
	}

	override public function init()
	{
		Console.enable();
		HXP.screen.color = kClearColor;
		// HXP.screen.scale = 1;
		start();
	}

	@:preload(
		["assets/graphics", "graphics"],
		["assets/sfx", "sfx"],
		["assets/music", "music"],
		["assets/font", "font"])
	function start()
	{
		HXP.scene = new MainWorld();
	}

	public static function main() new Main();

}
