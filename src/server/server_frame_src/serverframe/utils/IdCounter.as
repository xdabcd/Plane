package serverframe.utils
{
	public class IdCounter
	{
		private static var ids: Object = {};

		public static function getId(key: String): int
		{
			var id: int = ids[key];
			id || (id = 0);
			id ++;
			if (id >= 2147483647)
				id = 1;
			ids[key] = id;
			return id;
		}
	}
}

