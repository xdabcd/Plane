package serverframe.event
{
	/**
	 * 时间派发器。
	 * 
	 * @author Survivor
	 * 
	 */
	public class EventDispatcher
	{
		private var events:Object;
		
		public function EventDispatcher()
		{
			events = {};
		}
		
		/**
		 * 侦听事件。重复使用同一个侦听器侦听同一个事件无效。
		 * 
		 * @param name		事件名称
		 * @param host		作用域
		 * @param listener	侦听器
		 */
		public function on(name:String, host:Object, listener:Function):void
		{
			if(!events[name])
				events[name] = [];
			else
			{
				for(var i:int = events[name].length - 1; i >= 0; i--)
				{
					if(events[name][i][1] == listener)
						return;
				}
			}
			
			events[name].push([host, listener]);
		}
		
		/**
		 * 取消侦听的事件。如果事件列表中没有指定侦听，什么也不会发生。
		 * 
		 * @param name		事件名称
		 * @param host		作用域
		 * @param listener	侦听器
		 */
		public function off(name:String, host:Object, listener:Function):void
		{
			if(!events[name] || events[name].length === 0)
				return;
			
			for(var i:int = events[name].length - 1; i >= 0; i--)
			{
				if(events[name][i][1] == listener)
				{
					events[name].splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * 派发事件。
		 * 
		 * .
		 * @param name	事件名
		 * @param args	侦听器的参数，侦听器的签名是 function listener(args:Object):void
		 * 
		 */
		public function emit(name:String, args:Object):void
		{
			var eventList:Array = events[name];
			if(!eventList || eventList.length === 0)
				return;

			var listener:Function;
			for(var i:int = 0; i < eventList.length; i++)
			{
				listener = eventList[i];
				listener[1].call(listener[0], args);
			}
		}
	}
}