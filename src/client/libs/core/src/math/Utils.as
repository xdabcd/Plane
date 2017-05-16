package math
{
	import laya.maths.Point;

	public class Utils
	{
		public function Utils()
		{
		}

		public static function random(a: Number, b: Number): Number
		{
			return a + Math.random() * (b - a);
		}

		public static function randomInt(a: int, b: int): int
		{
			var min: int = Math.min(a, b);
			var max: int = Math.max(a, b);
			return Math.floor(random(min, max + 1));
		}

		public static function vecToDir(vec: Point):Number
		{
			return Math.atan2(vec.x, -vec.y);
		}

		public static function dirToVec(dir: Number): Point
		{
			var tp: Point = Point.TEMP;
			tp.setTo(Math.sin(dir), -Math.cos(dir));
			return tp;
		}

		public static function dirToAngle(dir: Number): Number
		{	
			return dir / Math.PI * 180;
		}
	}
}

