package utils
{
	public class Utils
	{
		/**
		 * 随机数
		 */
		public static function random(a: Number, b: Number): Number 
		{
			return a + Math.random() * (b - a);
		}

		/**
		 * 随机整数
		 */
		public static function randomInt(a: Number, b: Number): Number 
		{
			var min: Number = Math.min(a, b);
			var max: Number = Math.max(a, b);
			return Math.floor(random(min, max + 1));
		}

		/**
		 * 从数组中随机一个
		 */
		public static function randomFromArr(arr: Array): * 
		{
			if (!arr || !arr.length) return null;
			var index: int = randomInt(0, arr.length - 1);
			return arr[index];
		}

		/**
		 * 从数组中移除
		 */
		public static function removeFromArr(arr: Array, obj: *): void
		{
			var index: int = arr.indexOf(obj);
			arr.splice(index, 1);
		}
	}
}

