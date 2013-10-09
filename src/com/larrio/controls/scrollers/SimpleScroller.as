package com.larrio.controls.scrollers
{
	import com.larrio.controls.buttons.Button;
	import com.larrio.controls.events.ScrollEvent;
	import com.larrio.controls.interfaces.IScroller;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	
	/**
	 * 滑块数值发生变化时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 滑块停止滚动时派发
	 */
	[Event(name = "stopScrolling",type = "com.larrio.controls.events.ScrollEvent")]
	
	/**
	 * 滑块开始滚动时派发
	 */
	[Event(name = "startScrolling",type = "com.larrio.controls.events.ScrollEvent")]
	
	/**
	 * 简单化快，只包含上下两个按钮的滑块
	 * @author larryhou
	 */
	public class SimpleScroller extends EventDispatcher implements IScroller
	{
		protected var _preBtn:Button;
		protected var _nextBtn:Button;
		
		protected var _lineCount:int;
		
		protected var _value:Number;
		protected var _speed:Number;
		protected var _directon:int = -1;
		
		private var _enabled:Boolean;
		
		/**
		 * 构造函数
		 * create a [SimpleScroller] object
		 * @param	preBtn		向上翻的按钮
		 * @param	nextBtn		向下翻的按钮
		 */
		public function SimpleScroller(preBtn:DisplayObject, nextBtn:DisplayObject)
		{
			if (!preBtn || !nextBtn)
			{
				throw new ArgumentError("构造" + this + "对象时必须传入有效地参数！");
			}
			
			_preBtn = new Button(preBtn, true);
			_nextBtn = new Button(nextBtn, true);
			
			this.value = 0;
			this.speed = 1;
		}
		
		/**
		 * 添加事件侦听
		 */
		private function listen():void
		{
			_preBtn.mouseEnabled = _nextBtn.mouseEnabled = true;
			_preBtn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_nextBtn.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		private function unlisten():void
		{
			_preBtn.mouseEnabled = _nextBtn.mouseEnabled = false;
			_preBtn.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			_nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 鼠标按下
		 * @param	e
		 */
		protected function downHandler(e:MouseEvent):void 
		{
			var _button:Button = e.currentTarget as Button;
			if (_button == _preBtn)
			{
				_directon = -1;
			}
			else
			{
				_directon = 1;
			}
			
			_button.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			_preBtn.buttonView.addEventListener(Event.ENTER_FRAME, startRenderer);
			
			dispatchEvent(new ScrollEvent(ScrollEvent.START_SCROLLING));
		}
		
		/**
		 * 鼠标弹起处理
		 * @param	e
		 */
		protected function upHandler(e:MouseEvent):void
		{
			dispatchEvent(new ScrollEvent(ScrollEvent.STOP_SCROLLING));
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			_preBtn.buttonView.removeEventListener(Event.ENTER_FRAME, startRenderer);
		}
		
		/**
		 * 开始渲染
		 * @param	e
		 */
		protected function startRenderer(e:Event = null):void 
		{
			if (isNaN(_value)) _value = 0;
			_value += _speed * _directon;
			
			if (_value > 100)
			{
				_value = 100;
				
				_preBtn.mouseEnabled = true;
				_nextBtn.mouseEnabled = false;
			}
			else
			if(_value < 0)
			{
				_value = 0;
				
				_preBtn.mouseEnabled = false;
				_nextBtn.mouseEnabled = true;
			}
			else
			{
				_preBtn.mouseEnabled = true;
				_nextBtn.mouseEnabled = true;
			}
			
			notify();
		}
		
		/**
		 * 广播通知
		 */
		protected final function notify():void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		// getter & setter
		//*************************************************
		/**
		 * 数值
		 */
		public function get value():Number { return _value; }
		public function set value(value:Number):void 
		{
			if (isNaN(value)) value = 0;
			_value = Math.max(0, Math.min(100, value));
		}
		
		/**
		 * 是否激活鼠标事件
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			_enabled? listen() : unlisten();
		}
		
		/**
		 * 总行数
		 */
		public function get lineCount():int { return _lineCount; }
		public function set lineCount(value:int):void 
		{
			_lineCount = Math.max(0, value);
		}
		
		/**
		 * 滚动速度
		 */
		public function get speed():Number { return _speed; }
		public function set speed(value:Number):void 
		{
			if (isNaN(value)) value = 1;
			_speed = Math.max(0, Math.min(100, value));
		}
	}

}