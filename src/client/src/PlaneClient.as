package {
	import game.GameCenter;

	import laya.display.Stage;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;

	import scene.SceneManager;

	public class PlaneClient {

		public function PlaneClient() {
			//初始化引擎
			Laya.init(1136, 640, WebGL);
			Laya.stage.scaleMode = Stage.SCALE_FIXED_HEIGHT;
			Laya.stage.screenMode = Stage.SCREEN_HORIZONTAL;
			Stat.show();

			var res: Array = [
				{url: "res/atlas/plane.json", type: Loader.ATLAS},
				{url: "res/atlas/comp.json", type: Loader.ATLAS},
				{url: "bg.jpg", type: Loader.IMAGE}	
				];
			Laya.loader.load(res, Handler.create(this, onLoaded));
		}	

		private function onLoaded():void
		{
			GameCenter.I.init();
			SceneManager.I.menuScene.open();
		}
	}
}

