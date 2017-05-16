package game
{
	import MessageBase;

	import MessageManager;

	import cMsg.CMSGChangeDirection;
	import cMsg.CMSGUserInfo;

	import common.Global;

	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.utils.Byte;

	import net.SocketManager;

	import sMsg.SMSGEnterRoom;
	import sMsg.SMSGUserChange;
	import sMsg.SMSGUserEnter;
	import sMsg.SMSGUserLeave;

	import scene.SceneManager;

	import utils.Logger;
	import utils.UUID;
	import utils.Utils;

	public class GameCenter extends EventDispatcher
	{
		public static var I: GameCenter = new GameCenter;

		private var uuid: String;
		private var helpByte: Byte = new Byte;

		public function GameCenter()
		{
			helpByte.endian = Byte.LITTLE_ENDIAN;
		}

		public function init():void
		{
			uuid = UUID.create();
			MessageManager.I.init();
			SocketManager.I.connect();
			SocketManager.I.on(Event.OPEN, this, onConnect);
			SocketManager.I.on(Event.MESSAGE, this, onMessage);
		}

		private function onConnect():void
		{	
		}

		private function onMessage(data: *):void
		{
			var msg: * = readMessage(data);
			var key: String = MessageBase.ID_SIGN;
			switch(msg.msgId)
			{
				case SMSGEnterRoom[key]:
					enterRoomHanler(msg);
					break;
				case SMSGUserEnter[key]:
					userEnterHanler(msg);
					break;
				case SMSGUserChange[key]:
					userChangeHanler(msg);
					break;
				case SMSGUserLeave[key]:
					userLeaveHanler(msg);
					break;
			}
		}

		public function enterGame(name: String):void
		{
			var msg: CMSGUserInfo = getMessage(CMSGUserInfo);
			msg.name = name;
			msg.skin = Utils.random(1, Global.SKIN_CNT);
			sendMessage(msg);
		}

		public function changeDirection(direction: Number):void
		{
			var msg: CMSGChangeDirection = getMessage(CMSGChangeDirection);
			msg.direction = direction;
			sendMessage(msg);
		}

		private function enterRoomHanler(msg: *):void
		{
			SceneManager.I.menuScene.close();
			SceneManager.I.gameScene.open();
			SceneManager.I.gameScene.init(msg);
		}

		private function userChangeHanler(msg: *):void
		{
			SceneManager.I.gameScene.changeUser(msg);
		}

		private function userEnterHanler(msg: *):void
		{
			SceneManager.I.gameScene.addUser(msg);
		}

		private function userLeaveHanler(msg: *):void
		{
			SceneManager.I.gameScene.removeUser(msg);
		}

		private function readMessage(data: *): IMessage
		{
			helpByte.clear();
			helpByte.writeArrayBuffer(data);
			return MessageManager.I.readMessage(helpByte);
		}

		private function sendMessage(msg: MessageBase):void
		{
			MessageManager.I.writeMessage(msg, helpByte);
			SocketManager.I.send(helpByte.buffer);
		}

		private function getMessage(clz: Class): *
		{
			return MessageManager.I.getMessageByClass(clz);
		}
	}
}

