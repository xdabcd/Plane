package serverframe.utils
{
	public class NodeJS
	{
		public static var require:* = __JS__("require");

		private static var quad_tree: Object = require("quad-tree/build/Release/quad_tree");
		public static var Rect: Class = quad_tree.Rect;
		public static var QuadTree: Class = quad_tree.QuadTree;

		public function NodeJS()
		{
		}

		public static function now(): Number
		{
			return __JS__('Date').now();
		}

		public static function setInterval(listener: Function, time: Number):void
		{
			__JS__("setInterval")(listener, time);
		}
	}
}

