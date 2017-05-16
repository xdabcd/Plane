package game
{
	import cMsg.CMSGChangeDirection;
	import cMsg.CMSGUserInfo;

	import common.Config;

	import element.PlayerElement;

	import laya.utils.Byte;

	import manager.RoomManager;

	import serverframe.data.IRecoverable;
	import serverframe.event.Event;
	import serverframe.event.ServerDispatcher;
	import serverframe.net.WebSocketClient;
	import serverframe.objectPool.PoolManager;
	import serverframe.utils.IdCounter;

	public class Client implements IRecoverable
	{
		public static const CLASS_NAME: String = "game.Client";

		private static var helpByte: Byte = new Byte;

		private var _id: int;
		private var _player: PlayerElement;
		private var socket: WebSocketClient;

		public var dispatcher: ServerDispatcher;

		public function Client ()
		{
			helpByte.endian = Byte.LITTLE_ENDIAN;

			_player = new PlayerElement;
			_player.elementId = _player.userInfo.userId = _id = IdCounter.getId(CLASS_NAME);
		}

		public function init(ws: WebSocketClient):void
		{
			player.speed = Config.I.planeSpeed;

			socket = ws;
			socket.on(Event.MESSAGE, messageHandler.bind(this));
			socket.on(Event.CLOSE, closeHandler.bind(this));
			socket.on(Event.ERROR, errorHandler.bind(this));
		}

		private function messageHandler(data: *):void
		{
			var msg: * = readMessage(data);
			var key: String = MessageBase.ID_SIGN;
			switch(msg.msgId)
			{
				case CMSGUserInfo[key]:
					userInfoHandler(msg);
					break;
				case CMSGChangeDirection[key]:
					changeDirectionHandler(msg);
					break;
			}

		}

		private function closeHandler():void
		{
			emit(GameEvent.CLIENT_CLOSR);
		}

		private function errorHandler():void
		{

		}

		private function userInfoHandler(msg: CMSGUserInfo):void
		{
			_player.userInfo.name = msg.name;
			_player.userInfo.skin = msg.skin;
			RoomManager.I.addUser(this);
		}

		private function changeDirectionHandler(msg: CMSGChangeDirection):void
		{
			player.direction = msg.direction;
			player.updateUserInfo();
			emit(GameEvent.USER_CHANGE);
		}

		public function recover():void
		{
			socket.removeAllListeners(Event.MESSAGE);
			socket.removeAllListeners(Event.CLOSE);
			socket.removeAllListeners(Event.ERROR);
			socket.close();

			PoolManager.releaseIntoPool(CLASS_NAME, this);
		}

		public function sendMessage(msg: IMessage):void
		{
			MessageManager.I.writeMessage(msg, helpByte);
			socket && socket.send(helpByte.buffer);
		}

		private function readMessage(msg: *): IMessage
		{
			helpByte.clear();
			helpByte.writeArrayBuffer(msg);
			return MessageManager.I.readMessage(helpByte);
		}

		private function emit(event: String):void
		{
			dispatcher && dispatcher.emit(event, this);
		}

		public function get player(): PlayerElement
		{
			return _player;
		}

		public function get id(): int
		{
			return _id;
		}
	}
}

