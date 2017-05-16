package scene
{
	import game.GameScene;

	import menu.MenuScene;

	public class SceneManager
	{
		public static var I: SceneManager = new SceneManager;

		private var cur: IScene;
		private var _menuScene: MenuScene;
		private var _gameScene: GameScene;

		public function get menuScene(): MenuScene
		{
			return _menuScene || (_menuScene = new MenuScene);
		}

		public function get gameScene():GameScene
		{
			return _gameScene || (_gameScene = new GameScene);
		}
	}
}

