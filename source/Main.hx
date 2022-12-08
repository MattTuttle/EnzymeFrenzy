import haxepunk.Engine;
import haxepunk.HXP;
import scenes.MainMenu;

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

    @:preload("assets/graphics", "graphics")
    @:preload("assets/sfx", "sfx")
    @:preload("assets/music", "music")
    @:preload("assets/font", "font")
	override public function init()
	{
#if debug
        HXP.console.enable();
#end
		HXP.screen.color = kClearColor;
		// HXP.screen.scale = 1;
		HXP.scene = new MainMenu();
	}

	public static function main() new Main();

}
