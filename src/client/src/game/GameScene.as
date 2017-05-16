package game
{
	import data.UserInfo;

	import element.PlayerElement;

	import game.object.Plane;

	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Pool;

	import math.Utils;

	import sMsg.SMSGEnterRoom;
	import sMsg.SMSGUserChange;
	import sMsg.SMSGUserEnter;
	import sMsg.SMSGUserLeave;

	import scene.IScene;

	import ui.GameUI;

	import utils.Logger;

	public class GameScene extends GameUI implements IScene
	{
		private var simulator: GameSimulator;
		private var gameWidth: Number;
		private var gameHeight: Number;
		private var playerId: int;
		private var player: Plane;
		private var planes: Object = {};
		private var curTime: Number;
		private var direction: Number;

		public function GameScene()
		{
			super();
			simulator = new GameSimulator;
		}

		public function open(...params: *):void
		{
			Laya.stage.addChild(this);
			Laya.stage.on(Event.RESIZE, this, onResize);
			onResize();
			Laya.timer.frameLoop(1, this, update);
			Laya.stage.on(Event.MOUSE_MOVE, this, mouseMove);
			curTime = sysTime;
		}

		public function init(msg: SMSGEnterRoom):void
		{
			Logger.info("playerId", msg.userId);
			playerId = msg.userId;
			gameWidth = msg.gameWidth;
			gameHeight = msg.gameHeight;
			updatePlanes(msg.userList);
		}

		public function changeUser(msg: SMSGUserChange):void
		{
			setPlane(msg.userinfo);
		}

		public function addUser(msg: SMSGUserEnter):void
		{
			setPlane(msg.userInfo);
		}

		public function removeUser(msg: SMSGUserLeave):void
		{
			removePlane(msg.userId);
		}

		private function update():void
		{
			var delta: Number = sysTime - curTime;
			simulator.update(delta);

			for each (var plane: Plane in planes) 
			{
				plane.update();
				if(plane.id == playerId){

				}
			}
			updateGameBox();
			curTime = sysTime;
		}

		private function mouseMove(event: Event):void
		{		
			var vec: Point = Point.TEMP;
			vec.setTo(planeBox.mouseX - player.x, planeBox.mouseY - player.y);
			var dir: Number = Utils.vecToDir(vec);
			if(dir != direction){
				direction = dir;
				player.changeDireciotn(dir);
				GameCenter.I.changeDirection(dir);
			}
		}

		private function updateGameBox():void
		{
			if(!player) return;
			planeBox.x = width / 2 - player.x;
			planeBox.y = height / 2 - player.y;
			bg.x = width / 2 - player.x * bg.width / gameWidth;
			bg.y = height / 2 - player.y * bg.height / gameHeight;
		}

		private function updatePlanes(userList: Array):void
		{
			for (var i:int = 0; i < userList.length; i++) 
			{
				setPlane(userList[i]);
			}
		}

		private function setPlane(userInfo: UserInfo):void
		{
			Logger.info("set plane:", userInfo.userId);
			var plane: Plane = planes[userInfo.userId] || newPlane(userInfo);
			plane.sync(userInfo);
		}

		private function newPlane(userInfo: UserInfo): Plane
		{
			var plane: Plane = Pool.getItemByClass("Plane", Plane);
			plane.init(userInfo.userId);
			plane.setName(userInfo.name);
			plane.setSkin(userInfo.skin);
			planes[userInfo.userId] = plane;
			planeBox.addChild(plane);
			planeBox.addChild(plane.nameLabel);
			simulator.addPlayer(plane.ele as PlayerElement);
			if(userInfo.userId == playerId) player = plane;
			return plane;
		}

		private function removePlane(userId: int):void
		{
			var plane: Plane = planes[userId];
			if(plane){
				delete planes[userId];
				simulator.removePlayer(plane.ele as PlayerElement);
				plane.recover();
			}
		}

		private function onResize():void
		{
			var scale: Number = Math.min(Laya.stage.width / Laya.stage.designWidth, Laya.stage.height / Laya.stage.designHeight);
			this.scale(scale,scale);
		}

		public function close(...params: *):void
		{
			Laya.stage.removeChild(this);
			Laya.stage.off(Event.RESIZE, this, onResize);
			Laya.timer.clear(this, update);
		}

		private function get sysTime(): Number
		{
			return Laya.timer.currTimer;
		}
	}
}

