// [2014-04-20 by tenchiwang] 為了可以真正的把 template 和 各個部分拆分. 所以決定不使用獨例的模式
package com.tenchiwang.manager
{
	public final class EventManager
	{
//		static private var _instance:EventManager;
//		
//		static public function getInstancet():EventManager
//		{
//			if(!_instance)
//				_instance = new EventManager(new SingletonEnforcer());
//			return _instance;
//		}
//		public function EventManager(sc:SingletonEnforcer){}
		
		private var eventList:Object = new Object();
		
		public function addListener(eventType:String, handler:Function):int
		{
			if(eventList[eventType] == undefined)
				eventList[eventType] = new Vector.<Function>();
			
			var vec:Vector.<Function> = eventList[eventType] as Vector.<Function>;
			vec.push(handler);
			
			return vec.length;
		}
		
		public function sendEvent(eventType:String, ...args):void
		{
			if(eventList[eventType] == undefined)
				return;
			
			var vec:Vector.<Function> = eventList[eventType] as Vector.<Function>;
			var len:int = vec.length;
			
			for(var i:int = 0; i < len; i++)
			{
				if(vec[i] != null)
					vec[i].apply(this, args);
			}
		}
		
		public function removeListener(eventType:String, handler:Function):void
		{
			if(eventList[eventType] == undefined)
				return;
			
			var vec:Vector.<Function> = eventList[eventType] as Vector.<Function>;
			var len:int = vec.length;
			
			for(var i:int = 0; i < len; i++)
			{
				if(vec[i] === handler)
				{
					vec[i] = null;
					return;
				}
			}
		}
		
		public function removeListenerAll(eventType:String):void
		{
			if(eventList[eventType] == undefined)
				return;
			
			var vec:Vector.<Function> = eventList[eventType] as Vector.<Function>;
			var len:int = vec.length;
			
			for(var i:int = 0; i < len; i++)
			{
					vec[i] = null;
			}
			
			vec = null;
			
			delete eventList[eventType];
		}
		
		public function clearAll():void
		{
			for(var key:String in eventList)
				removeListenerAll(key);
		}
		
	}
}

//internal class SingletonEnforcer{}