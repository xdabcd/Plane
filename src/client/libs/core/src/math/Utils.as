package math
{
	import laya.maths.Point;

	public class Utils
	{
		public function Utils()
		{
		}

		public static function vecToDir(vec: Point):Number
		{
			return Math.atan2(vec.x, -vec.y);
		}

		public static function dirToVec(dir: Number): Point
		{
			var tp: Point = Point.TEMP;
			tp.x = Math.sin(dir);
			tp.y = -Math.cos(dir);
			return tp;
		}

		public static function dirToAngle(dir: Number): Number
		{	
			return dir / Math.PI * 180;
		}
	}
}

