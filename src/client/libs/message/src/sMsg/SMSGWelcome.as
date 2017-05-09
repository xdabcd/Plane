package sMsg
{
	public class SMSGWelcome extends BaseMessage
	{
		public var time:Number;

		private var DES: Array = [
			["time", NUMBER]
			];

		public function SMSGWelcome()
		{
			super();
		}
	}
}

