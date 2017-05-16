package common
{
	import serverframe.utils.NodeJS;

	public class Config
	{
		public static var I: Config = new Config;

		public var configData: Object; 

		public function Config()
		{
		}

		public function init():void
		{
			configData = NodeJS.require("./res/config.json");
		}

		public function get gameWidth(): Number
		{
			return configData.game.width;
		}

		public function get gameHeight(): Number
		{
			return configData.game.height;			
		}

		public function get planeSpeed(): Number
		{
			return configData.game.plane.speed;			
		}

		public function get port(): int
		{
			return configData.socket.port;
		}
	}
}

