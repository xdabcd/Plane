package sMsg
{
	import data.UserInfo;

	public class SMSGEnterRoom extends BaseMessage
	{
		public var userId: int;
		public var gameTime:Number;
		public var leftTime:Number;
		public var userList: Array;

		private var DES: Array = [
			["userId", INT],
			["gameTime", NUMBER],
			["leftTime", NUMBER],
			["userList", ARRAY, [CLASS, UserInfo]]
			];

		public function SMSGEnterRoom()
		{
			super();
		}
	}
}

