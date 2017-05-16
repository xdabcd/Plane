package serverframe.event
{
	public class EventEmitter
	{
		public function EventEmitter()
		{
		}

		public function on(event: String, listener: Function):void
		{

		}

		public function emit(event: String, ...args):void
		{

		}

		public function once(event: String, listener: Function):void
		{

		}

		public function removeListener(event: String, listener: Function):void
		{

		}

		public function removeAllListeners(event: String):void
		{

		}

		public function setMaxListeners(n: int):void
		{

		}
	}
	__JS__('EventEmitter = require("events")');
}

