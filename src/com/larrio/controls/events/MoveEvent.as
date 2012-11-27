package com.larrio.controls.events 
{
	import flash.events.Event;
	
	/**
	 * 位置移动事件
	 * @author larryhou
	 * @createTime	2010/3/1 0:38
	 */
	public class MoveEvent extends Event 
	{
		/**
		 * 移动事件
		 */
		public static const START_MOVE:String = "startMove";
		
		/**
		 * 停止移动处理
		 */
		public static const STOP_MOVE:String = "stopMove";
		
		
		private var _data:* = null;
		
		/**
		 * 事件对象构造函数
		 * create a [MoveEvent] object
		 */
		public function MoveEvent(type:String,userData:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			_data = userData;
			
		} 
		
		/**
		 * 克隆事件对象
		 */
		public override function clone():Event 
		{ 
			return new MoveEvent(type,_data, bubbles, cancelable);
		} 
		
		/**
		 * 字符串表示
		 */
		public override function toString():String 
		{ 
			return formatToString("MoveEvent", "" + _data, "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * @return 返回事件对象携带数据
		 */
		public function get data():*{ return _data; }
		
	}
	
} 