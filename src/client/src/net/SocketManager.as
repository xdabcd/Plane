package net
{
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Socket;

	import utils.Logger;

	public class SocketManager extends EventDispatcher
	{
		public static const SERVER_IP: String = "172.16.27.246";
		public static const SERVER_PORT: int = 9001; 

		public static var I: SocketManager = new SocketManager;
		private var socket: Socket;

		public function SocketManager()
		{
		}

		public function connect():void
		{
			Logger.info("socket try connect...");
			Logger.info("ip: ", SERVER_IP);
			Logger.info("port: ", SERVER_PORT);

			socket = new Socket(SERVER_IP, SERVER_PORT);
			socket.on(Event.OPEN, this, onConnect);
			socket.on(Event.MESSAGE, this, onMessage);
			socket.on(Event.CLOSE, this, onClose);
			socket.on(Event.ERROR, this, onError);
		}

		public function send(data: *):void
		{
			socket && socket.send(data);
		}

		private function onConnect():void
		{
			Logger.info("socket onConnect...");
			this.event(Event.OPEN);
		}

		private function onMessage(data: *):void
		{
			this.event(Event.MESSAGE, data);
		}

		private function onClose():void
		{
			Logger.info("socket onClose...");
			socket = null;
		}

		private function onError():void
		{
			Logger.error("socket onError...");
		}
	}
}

