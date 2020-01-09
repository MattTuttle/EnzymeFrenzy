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
		HXP.screen.color = kClearColor;
		HXP.assetLoader.addShortcut("graphics", "assets/graphics");
		HXP.assetLoader.addShortcut("sfx", "assets/sfx");
		HXP.assetLoader.addShortcut("music", "assets/music");
#if js
		var preloader = new backend.html5.Preloader([
			"assets/graphics/cell.png",
			"assets/graphics/enzyme.png",
			"assets/graphics/germ.png",
			"assets/graphics/mother.png",
			"assets/graphics/overlay.png",
			"assets/graphics/title.png",
			"assets/music/background.mp3",
			"assets/sfx/explode.mp3",
			"assets/sfx/explosion.mp3",
			"assets/sfx/hit.mp3",
			"assets/sfx/pickup.mp3",
			"assets/sfx/slurp.mp3",
		]);
		preloader.onLoad.bind(function() {
#end
			HXP.scene = new MainWorld();
#if js
		});
		HXP.scene = preloader;
#end
		// HXP.screen.scale = 1;
	}

	public static function main()
	{
		new Main();
	}

}
