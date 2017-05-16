package sMsg
{
	import data.UserInfo;

	public class SMSGEnterRoom extends MessageBase
	{
		public var userId: int;
		public var time: Number;
		public var gameWidth: Number;
		public var gameHeight: Number;
		public var userList: Array;

		private var DES: Array = [
			["userId", INT],
			["time", NUMBER],
			["gameWidth", NUMBER],
			["gameHeight", NUMBER],
			["userList", ARRAY, [CLASS, UserInfo]]
			];

		public function SMSGEnterRoom()
		{
			super();
		}
	}
}

