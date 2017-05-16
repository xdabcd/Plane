package cMsg
{
	public class CMSGUserInfo extends MessageBase
	{
		public var name: String;
		public var skin: int;

		private var DES: Array = [
			["name", STRING],
			["skin", INT]
			];

		public function CMSGUserInfo()
		{
		}
	}
}

