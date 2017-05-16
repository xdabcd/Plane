package sMsg
{
	import data.UserInfo;

	public class SMSGUserChange extends MessageBase
	{
		public var time: Number;
		public var userinfo: UserInfo;

		private var DES:Array = 
			[
			["time", MessageBase.NUMBER],
			["userinfo", MessageBase.CLASS, UserInfo]
			];

		public function SMSGUserChange()
		{
			super();
		}
	}
}

