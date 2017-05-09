package sMsg
{
	import data.UserInfo;

	public class SMSGUserEnter extends BaseMessage
	{
		public var time: Number;
		public var userInfo: UserInfo;

		private var DES: Array = [
			["time", NUMBER],
			["userInfo", CLASS, UserInfo]
			];

		public function SMSGUserEnter()
		{
			super();
		}
	}
}

