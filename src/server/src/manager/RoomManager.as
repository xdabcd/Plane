package manager
{
	import game.Client;
	import game.Room;

	import serverframe.objectPool.PoolManager;

	public class RoomManager
	{
		public static var I: RoomManager = new RoomManager;

		private var rooms: Object = {};
		private var time: Number;

		public function RoomManager()
		{
		}

		public function init():void
		{
			Laya.timer.frameLoop(1, this, enterFrame);
			time = Laya.timer.currTimer;
		}

		private function enterFrame():void
		{
			var cur: Number = Laya.timer.currTimer;
			var delta: Number = cur - time;

			for each (var r: Room in rooms) 
			{
				r.update(delta);	
			}


			time = cur;
		}

		public function addUser(client: Client):void
		{
			var room: Room = getRoom();
			room.addClient(client);
		}

		private function getRoom(): Room
		{
			var room: Room;
			for each (var r: Room in rooms) 
			{
				if(!r.isFull){
					room = r;
					break;
				}
			}

			return room || newRoom();
		}

		private function newRoom(): Room
		{
			var room: Room = PoolManager.takeFromPool(Room.CLASS_NAME) as Room;
			room.init();
			rooms[room.id] = room;
			return room;
		}
	}
}

