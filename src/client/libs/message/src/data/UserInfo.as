package data
{
	public class UserInfo extends MessageBase
	{
		public var userId: int;	
		public var name: String;
		public var skin: int;
		public var x: Number;
		public var y: Number;
		public var speed: Number;
		public var direction: Number;

		private var DES: Array = [
			["userId", INT],
			["name", STRING],
			["skin", INT],
			["x", NUMBER],
			["y", NUMBER],
			["speed", NUMBER],
			["direction", NUMBER]
			];

		public function UserInfo()
		{
			super();
		}
	}
}

