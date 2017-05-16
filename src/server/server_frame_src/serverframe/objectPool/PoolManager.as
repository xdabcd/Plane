package serverframe.objectPool
{
	/**
	 * 对象池管理器。
	 * 提供系列静态操作。
	 *  
	 * @author Survivor
	 */
	public class PoolManager
	{
		private static var pools:Object = {};

		/**
		 * 初始化池。
		 * 
		 * @param poolName      池名。
		 * @param initialSize   初始池大小。
		 * @param rise          对象池的增长幅度，决定对象池满后的行为。
		 *                      如果涨幅为0，对象池空，get()会返回null。
		 * @param storageClass  对象池内保存的对象类型。
		 * 
		 */
		public static function initPool(poolName:String, initialSize:int, rise:int, storageClass:Class):void
		{
			var pool:ObjectPool = new ObjectPool(initialSize, rise, storageClass);
			pools[poolName] = pool;
		}

		/**
		 * 从池中取出对象。
		 * 
		 * @param poolName   如果该池未初始化，将发生空对象异常。
		 * @return           从池中取出的对象，如果该池涨幅为0，并且池空，返回null。 
		 */
		public static function takeFromPool(poolName:String):Object
		{
			return ((pools[poolName] as ObjectPool).getObject());
		}

		/**
		 * 将对象释放入指定池中。
		 * 
		 * @param poolName  如果该池未初始化，将发生空对象异常。
		 * @param object    释放入池中的对象。
		 * @param resetFunc 回收时调用的函数，不调用任何函数可传入null。
		 */
		public static function releaseIntoPool(poolName:String, object:Object):void
		{
			(pools[poolName] as ObjectPool).release(object);
		}
		
		public static function getPool(poolName:String):ObjectPool
		{
			return pools[poolName];
		}
	}
}