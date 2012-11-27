package com.larrio.controls.events 
{
	import flash.events.Event;
	
	/**
	 * 滑块组件滚动事件
	 * @author larryhou
	 */
	public class ScrollEvent extends Event 
	{
		/**
		 * 停止滚动
		 */
		public static const STOP_SCROLLING:String = "stopScrolling";
		
		/**
		 * 开始滚动
		 */
		public static const START_SCROLLING:String = "startScrolling";
		
		/**
		 * 自定义数据
		 */
		private var _data:* = null;
		
		/**
		 * 事件对象构造函数
		 * create a [ScrollEvent] object
		 */
		public function ScrollEvent(type:String, userData:*= null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{ 
			super(type, bubbles, cancelable);
			
			_data = userData;
			
		} 
		
		/**
		 * 克隆事件对象
		 */
		public override function clone():Event 
		{ 
			return new ScrollEvent(type, _data, bubbles, cancelable);
		} 
		
		/**
		 * 字符串表示
		 */
		public override function toString():String 
		{ 
			return formatToString("ScrollEvent", "" + _data, "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * @return 返回事件对象携带数据
		 */
		public function get data():*{ return _data; }
		
	}
	
} 