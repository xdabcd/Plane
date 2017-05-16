package
{	
	import common.Config;

	import game.Client;
	import game.Room;

	import manager.RoomManager;

	import serverframe.event.Event;
	import serverframe.net.WebSocketClient;
	import serverframe.net.WebSocketServer;
	import serverframe.objectPool.PoolManager;

	public class PlaneServer
	{
		public function PlaneServer()
		{
			PoolManager.initPool(Client.CLASS_NAME, 1000, 20, Client);
			PoolManager.initPool(Room.CLASS_NAME, 100, 100, Room);
			MessageManager.I.init();
			RoomManager.I.init();
			Config.I.init();

			var port: int = Config.I.port;
			var server: WebSocketServer = new WebSocketServer({port: port});
			server.on(Event.Connection, clientHandler);
			trace("启动游戏服务器...");
			trace("port: " + port);
		}

		private function clientHandler(ws: WebSocketClient):void
		{
			var client: Client = PoolManager.takeFromPool(Client.CLASS_NAME) as Client;
			client.init(ws);
		}
	}
}

