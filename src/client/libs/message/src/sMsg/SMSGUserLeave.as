package sMsg
{
	public class SMSGUserLeave extends MessageBase
	{
		public var userId: int;

		private var DES: Array = [
			["userId", INT]
			];

		public function SMSGUserLeave()
		{
			super();
		}
	}
}

