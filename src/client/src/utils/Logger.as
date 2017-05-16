package utils
{
	public class Logger
	{
		private static const levelNames: Array = ["Debug","Info","Error"];
		private static const levelColors: Array = ["#5180CE","#6B8E24","#FF0000"];

		public function Logger()
		{
		}

		public static function debug(...args):void
		{
			log(argumentToString(args), 0);
		}

		public static function info(...args):void
		{
			log(argumentToString(args), 1);
		}

		public static function error(...args):void
		{
			log(argumentToString(args), 2);
		}

		private static function log(str: String, level: int):void
		{
			str = "[" + levelNames[level] + "]: " + str;
			console.log("%c" + str, "color:" + levelColors[level]);
		}

		private static function argumentToString(args: Array): String
		{
			var str: String = "";
			for (var i:int = 0; i < args.length; i++) 
			{
				str += args[i] + " ";
			}
			return str;
		}
	}
}

