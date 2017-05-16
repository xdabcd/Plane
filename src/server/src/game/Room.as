package game
{
	import element.PlayerElement;

	import manager.MessageSendManager;

	import serverframe.event.ServerDispatcher;
	import serverframe.objectPool.PoolManager;
	import serverframe.utils.IdCounter;

	public class Room
	{
		public static const CLASS_NAME: String = "game.Room";
		public static const MAX_SIZE: int = 20;

		private var _id: int;
		private var clients: Object = {};
		private var _userList: Array;
		private var gameTimeCountdown: Number = 1000 * 60 * 5;
		private var simulator: GameSimulator;

		public var dispatcher: ServerDispatcher;

		public function Room()
		{
			_id = IdCounter.getId(CLASS_NAME);

			dispatcher = new ServerDispatcher();
			dispatcher.on(GameEvent.CLIENT_CLOSR, removeClient.bind(this));
			dispatcher.on(GameEvent.USER_CHANGE, userChange.bind(this));

			simulator = new GameSimulator;
		}

		public function init():void
		{

		}

		public function update(delta: Number):void
		{
			gameTimeCountdown -= delta;
			simulator.update(delta);
		}

		public function addClient(client: Client):void
		{
			trace("添加用户:" + client.id);
			simulator.addPlayer(client.player);
			client.dispatcher = dispatcher;
			clients[client.id] = client;
			for each (var c: Client in clients) 
			{
				c.player.updateUserInfo();
			}
			MessageSendManager.I.enterRoomHanler(client, this);
		}

		public function removeClient(client: Client):void
		{
			trace("删除断线删除用户" + client.id);
			client.dispatcher = null;
			delete clients[client.id];
			simulator.removePlayer(client.player);
			client.recover();

			MessageSendManager.I.userLeaveHandler(client, this);
		}

		private function userChange(client: Client):void
		{
			MessageSendManager.I.changeDirectionHandler(client, this);
		}

		public function sendAll(msg: IMessage):void
		{
			for each (var c: Client in clients) 
			{
				c.sendMessage(msg);
			}
		}

		public function sendToOtherClient(userId: int, msg: IMessage):void
		{
			for each (var c: Client in clients) 
			{
				if(c.id != userId)
					c.sendMessage(msg);
			}
		}

		public function recover():void
		{
			clients = [];
			PoolManager.releaseIntoPool(CLASS_NAME, this);
		}

		public function get userList(): Array
		{
			_userList = [];
			var player: PlayerElement;
			for each (var c: Client in clients) 
			{
				player = c.player;
				if(!player.isDead){
					_userList.push(player.userInfo);
				}
			}
			return _userList;
		}

		public function get isFull(): Boolean
		{
			return clients.length >= MAX_SIZE;
		}

		public function get id(): int
		{
			return _id;
		}

		public function get leftTime(): Number
		{
			return gameTimeCountdown;
		}
	}
}

