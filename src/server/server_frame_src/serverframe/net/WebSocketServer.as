package serverframe.net
{
	import serverframe.event.EventEmitter;

	public class WebSocketServer extends EventEmitter
	{
		public function WebSocketServer(option: *)
		{
		}
	}
	__JS__('WebSocketServer = require("uws").Server');
}

