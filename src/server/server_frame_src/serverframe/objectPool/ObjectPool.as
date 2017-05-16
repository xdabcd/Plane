package serverframe.objectPool
{
	/**
	 * 可变长度的对象池。
	 *
	 * @author Survivor
	 */
	public class ObjectPool
	{
		private var freePool:Array;
//		private var activePool:Array;
		private var activeAmount:int;
		
		private var rise:int;
		private var storageClass:Class;
		private var constructorArgs:Array;
		
		/**
		 * 创建指定大小的对象池。
		 *
		 * @param initialSize     初始对象池大小
		 * @param rise            对象池的增长幅度，绝对对象池满后的行为
		 *                        如果涨幅为0，对象池空，get()会返回null
		 * @param storageClass    对象池内保存的对象类型，需实现IRecoverable
		 * @param constructorArgs 初始化对象池内对象的构造函数所用参数，null代表无参或全都为默认值
		 */
		public function ObjectPool(initialSize:int, rise:int, storageClass:Class, constructorArgs:Array = null)
		{
			this.rise = rise;
			this.storageClass = storageClass;
			
			initPool(initialSize);
		}
		
		/**
		 * 初始化变量以及分配池
		 * @param initialSize 初期对象池大小
		 */
		private function initPool(initialSize:int):void
		{
			freePool = [];
//			activePool = [];
			
			allocNewObjects(initialSize);
		}
		
		/**
		 * 给对象池及分配新对象。
		 * 
		 * @param count 新增的对象个数。
		 */
		private function allocNewObjects(count:int):void
		{
			for(var i:int = 0; i < count; ++i)
			{
				freePool.push(new storageClass());
			}
		}
		
		/**
		 * 从对象池中取出对象。可能返回null。
		 * 
		 * @return 如果对象池非空，返回池内对象，池大小减少。
		 *         如果对象池空，并且rise大于0，则增长对象池并返回池内对象；否则返回null。
		 */
		public function getObject():Object
		{
			if(freePool.length > 0)
			{
				var obj:Object = freePool.pop();
//				activePool.push(obj);
				activeAmount++;
				return obj;
			}
			else if(rise > 0)
			{
				allocNewObjects(rise);
				return getObject();
			}
			
			return null;
		}
		
		/**
		 * 释放指定对象，对象池大小增加。
		 * 
		 * @param object           存入对象池的对象。
		 */
		public function release(object:Object):void
		{
			activeAmount--;
			freePool.push(object);
		}
		
		/**
		 * 获取空闲对象的数量。
		 */
		public function getFreeQuantity():int
		{
			return freePool.length;
		}
		
		/**
		 * 获取正在活动的对象数量。 
		 */
		public function getActiveQuantity():int
		{
			return activeAmount;
		}
	}
}