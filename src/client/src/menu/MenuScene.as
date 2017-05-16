package menu
{
	import game.GameCenter;
	import user.UserDataKey;
	import user.UserDataManager;

	import laya.events.Event;

	import ui.MenuUI;
	import scene.IScene;

	public class MenuScene extends MenuUI implements IScene
	{
		private var name: String;

		public function MenuScene()
		{
			super();
			nameInput.on(Event.BLUR, this, setName);
			startBtn.on(Event.CLICK, this, start);

			name = UserDataManager.I.getUserData(UserDataKey.NAME);
			if(name){
				nameInput.text = name;
			}else{
				nameInput.focus = true;
			}
		}

		public function open(...params: *):void
		{
			Laya.stage.addChild(this);
			Laya.stage.on(Event.RESIZE, this, onResize);
			onResize();
		}

		private function onResize():void
		{
			var scale: Number = Math.min(Laya.stage.width / Laya.stage.designWidth, Laya.stage.height / Laya.stage.designHeight);
			this.scale(scale,scale);
		}

		private function setName():void
		{
			name = nameInput.text;
			UserDataManager.I.setUserData(UserDataKey.NAME, name);
		}

		private function start():void
		{
			GameCenter.I.enterGame(name);
		}

		public function close(...params: *):void
		{
			Laya.stage.removeChild(this);
			Laya.stage.off(Event.RESIZE, this, onResize);
		}
	}
}

