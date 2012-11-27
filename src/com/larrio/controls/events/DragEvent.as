package com.larrio.controls.events 
{
	import flash.events.Event;
	
	/**
	 * 拖动事件
	 * @author larryhou
	 */
	public class DragEvent extends Event 
	{
		/**
		 * 开始拖动
		 */
		public static const START_DRAG:String = "startDrag";
		
		/**
		 * 停止拖动
		 */
		public static const STOP_DRAG:String = "stopDrag";
		
		/**
		 * 一次滚动完成
		 */
		public static const DRAG_COMPLETE:String = "dragComplete";
		
		
		private var _data:* = null;
		
		/**
		 * 事件对象构造函数
		 * create a [DragEvent] object
		 */
		public function DragEvent(type:String,userData:*=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
			_data = userData;
			
		} 
		
		/**
		 * 克隆事件对象
		 */
		public override function clone():Event 
		{ 
			return new DragEvent(type,_data, bubbles, cancelable);
		} 
		
		/**
		 * 字符串表示
		 */
		public override function toString():String 
		{ 
			return formatToString("DragEvent", "" + _data, "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		/**
		 * @return 返回事件对象携带数据
		 */
		public function get data():*{ return _data; }
		
	}
	
} 