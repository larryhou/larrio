package com.larrio.controls.scrollers.bar 
{
	import com.larrio.controls.events.MoveEvent;
	import com.larrio.controls.interfaces.IComponent;
	
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 滑块位置发生改变时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 滑块开始移动时派发
	 */
	[Event(name = "startMove", type = "com.larrio.controls.events.MoveEvent")]
	
	/**
	 * 滑块停止移动时派发
	 */
	[Event(name = "stopMove", type = "com.larrio.controls.events.MoveEvent")]
	
	/**
	 * 滚动条滑块
	 * @author larryhou
	 * @createTime	2010/2/28 23:29
	 */
	public class SimpleBar extends EventDispatcher implements IComponent
	{
		//////////////////////////////////////////////////////////////////////////
		// static members
		private static const ROLL_OUT:String = "out";
		private static const ROLL_OVER:String = "over";
		private static const MOUSE_DOWN:String = "down";
		
		//////////////////////////////////////////////////////////////////////////
		// protected members
		protected var _minWidth:Number = 0;
		protected var _minHeight:Number = 60;
		
		protected var _view:MovieClip;
		protected var _dragRect:Rectangle;
		
		private var _map:Dictionary;
		private var _enabled:Boolean = false;
		
		/**
		 * 构造函数
		 * create a [SimpleBar] object
		 */
		public function SimpleBar(barView:MovieClip)
		{
			_view = barView;
			_view.mouseChildren = false;
			
			_minWidth = _view.width;
			
			_map = new Dictionary();
			var scene:Scene = _view.scenes[0];
			for each(var label:FrameLabel in scene.labels)
			{
				if (label.name)
				{
					_map[label.name] = label;
				}
			}
		}
		
		/**
		 * 添加时间侦听
		 */
		protected function addListener():void
		{
			_view.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_view.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			_view.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		protected function removeListener():void
		{
			_view.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_view.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			_view.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			if (_view.stage)
			{
				_view.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			}
		}
		
		/**
		 * 鼠标弹起事件
		 * @param	e
		 */
		protected function outHandler(e:MouseEvent):void 
		{
			if (_map[ROLL_OUT])
			{
				_view.gotoAndStop(ROLL_OUT);
			}
		}
		
		/**
		 * 鼠标滑过处理
		 * @param	e
		 */
		protected function overHandler(e:MouseEvent):void 
		{
			if (_map[ROLL_OVER])
			{
				_view.gotoAndStop(ROLL_OVER);
			}
		}
		
		/**
		 * 鼠标按下处理
		 * @param	e
		 */
		protected function downHandler(e:MouseEvent):void 
		{
			_view.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			if (_map[MOUSE_DOWN]) 
			{
				_view.gotoAndStop(MOUSE_DOWN);
			}
			
			_view.startDrag(false, _dragRect);
			_view.addEventListener(Event.ENTER_FRAME, frameHandler);
			
			dispatchEvent(new MoveEvent(MoveEvent.START_MOVE));
		}
		
		private function frameHandler(e:Event):void 
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 鼠标弹起处理
		 * @param	e
		 */
		protected function upHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			_view.stopDrag();
			_view.removeEventListener(Event.ENTER_FRAME, frameHandler);
			
			dispatchEvent(e);
			dispatchEvent(new MoveEvent(MoveEvent.STOP_MOVE));
			
			var target:DisplayObject = e.target as DisplayObject;
			
			if (_view.contains(target))
			{
				if (_map[ROLL_OVER])
				{
					_view.gotoAndStop(ROLL_OVER);
				}
				
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else
			{
				if (_map[ROLL_OUT])
				{
					_view.gotoAndStop(ROLL_OUT);
				}
				
				dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
			}
		}
		
		//-----------------------------------------------------------
		//	Getters & Setters
		//-----------------------------------------------------------
		/**
		 * 最小高度
		 */
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(value:Number):void 
		{
			_minHeight = Math.max(30, value);
		}
		
		/**
		 * 滑块高度
		 */
		public function get height():Number { return _view.height; }
		public function set height(value:Number):void 
		{
			_view.height = Math.max(value, _minHeight);
		}
		
		/**
		 * 滑块宽度
		 */
		public function get width():Number { return _view.width; }
		public function set width(value:Number):void
		{
			_view.width = Math.max(value, _minWidth);			
		}
		
		/**
		 * 横坐标
		 */
		public function get x():Number { return _view.x; }
		public function set x(value:Number):void 
		{
			value = Math.max(value, _dragRect.x);
			value = Math.min(value, _dragRect.x + _dragRect.width);
			
			if (value == _view.x) return;
			
			_view.x = value;
		}
		
		/**
		 * 竖坐标
		 */
		public function get y():Number { return _view.y; }
		public function set y(value:Number):void
		{
			value = Math.max(value, _dragRect.y);
			value = Math.min(value, _dragRect.y + _dragRect.height);
			
			if (value == _view.y) return;
			
			_view.y = value;
		}
		
		/**
		 * 是否可见
		 */
		public function get visible():Boolean { return _view.visible; }
		public function set visible(value:Boolean):void 
		{
			_view.visible = value;
		}
		
		/**
		 * 是否激活鼠标事件
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			
			_enabled? addListener() : removeListener();
		}
		
		/**
		 * 可拖动区域
		 */
		public function get dragRect():Rectangle { return _dragRect ||= new Rectangle(); }
		public function set dragRect(value:Rectangle):void 
		{
			_dragRect = value;
		}
		
		/**
		 * 拖动滑块视图
		 */
		public function get view():MovieClip { return _view; }		
		
	}
	
}