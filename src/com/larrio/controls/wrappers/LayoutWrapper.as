package com.larrio.controls.wrappers 
{
	import com.larrio.controls.events.ScrollEvent;
	import com.larrio.controls.interfaces.IController;
	import com.larrio.controls.interfaces.IScroller;
	import com.larrio.controls.layout.BasicLayout;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * 滚动布局类
	 * @author larryhou
	 */
	public class LayoutWrapper extends EventDispatcher implements IController
	{
		private var _scroller:IScroller = null;
		
		private var _layout:BasicLayout = null;
		
		private var _enabled:Boolean = false;
		
		private var _value:Number = 0;
		
		/**
		 * 构造函数
		 * create a [LayoutWrapper] object
		 */
		public function LayoutWrapper(layout:BasicLayout, scroller:IScroller)
		{
			_layout = layout;
			_scroller = scroller;
			
			if (!_layout)
			{
				throw new ArgumentError("传入的layout参数不能为null!");
			}
			
			if (!_scroller)
			{
				throw new ArgumentError("传入的scroller参数不能为null!");
			}
		}
		
		//------------------------------------------
		// Public APIs
		//------------------------------------------
		
		public function scrollTo(dataIndex:int):void
		{
			_layout.scrollTo(dataIndex);
			
			_scroller.value = _layout.value;
		}
		
		//------------------------------------------
		// Private APIs
		//------------------------------------------
		/**
		 * 添加事件侦听
		 */
		private function addListener():void
		{
			_layout.addEventListener(Event.CHANGE, layoutChangeHandler);
			
			_scroller.addEventListener(Event.CHANGE, scrollerChangeHandler);
			_scroller.addEventListener(ScrollEvent.STOP_SCROLLING, stopScrollHandler);
			_scroller.addEventListener(ScrollEvent.START_SCROLLING, startScrollHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		private function removeListener():void
		{
			_layout.removeEventListener(Event.CHANGE, layoutChangeHandler);
			
			_scroller.removeEventListener(Event.CHANGE, scrollerChangeHandler);
			_scroller.removeEventListener(ScrollEvent.STOP_SCROLLING, stopScrollHandler);
			_scroller.removeEventListener(ScrollEvent.START_SCROLLING, startScrollHandler);
		}
		
		/**
		 * 滑块滚动处理
		 * @param	e
		 */
		private function scrollerChangeHandler(e:Event):void 
		{
			e.stopPropagation();
			
			_layout.value = _scroller.value;
		}
		
		/**
		 * 滑块开始滚动处理
		 * @param	e
		 */
		private function startScrollHandler(e:ScrollEvent):void
		{
			e.stopPropagation();
			
			_layout.scrolling = true;
		}
		
		/**
		 * 滑块开始滚动处理
		 * @param	e
		 */
		private function stopScrollHandler(e:ScrollEvent):void 
		{
			e.stopPropagation();
			
			_layout.scrolling = false;
		}
		
		/**
		 * 列表滚动处理
		 * @param	e
		 */
		private function layoutChangeHandler(e:Event):void
		{
			e.stopPropagation();
			
			_scroller.value = _layout.value;
		}
		
		//------------------------------------------
		// Getters & Setters
		//------------------------------------------
		/**
		 * 是否激活控件
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			_layout.enabled = _enabled;
			_scroller.enabled = _enabled;
			
			_enabled ? addListener() : removeListener();
		}
		
		/**
		 * 传入列表数据
		 */
		public function get dataProvider():Array { return _layout.dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_layout.dataProvider = value;
			
			_scroller.lineCount = _layout.lineCount;
		}
		
		/**
		 * 列表以及滑块的数值
		 */
		public function get value():Number { return _scroller.value; }
		public function set value(targetValue:Number):void
		{
			_layout.value = targetValue;
			_scroller.value = targetValue;
		}
		
		/**
		 * 布局类
		 */
		public function get layout():BasicLayout { return _layout; }
		
		/**
		 * 滚动控制器
		 */
		public function get scroller():IScroller { return _scroller; }
	}

}