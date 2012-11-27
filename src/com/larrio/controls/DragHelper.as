package com.larrio.controls 
{
	import com.greensock.TweenLite;
	import com.larrio.controls.events.DragEvent;
	import com.larrio.controls.interfaces.IController;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * 交互显示对象正在被拖动时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 开始拖动时派发
	 */
	[Event(name = "startDrag", type = "com.larrio.controls.events.DragEvent")]
	
	/**
	 * 停止拖动时派发
	 */
	[Event(name = "stopDrag", type = "com.larrio.controls.events.DragEvent")]
	
	/**
	 * 单次滚动完成时派发
	 */
	[Event(name = "dragComplete", type = "com.larrio.controls.events.DragEvent")]

	/**
	 * 拖拽增强控件
	 * @author larryhou
	 */
	public class DragHelper extends EventDispatcher implements IController
	{
		// 被拖动物体
		private var _target:InteractiveObject;
		
		// 缓动相关
		private var _ease:Function;
		private var _duration:Number = 0.5;
		
		// 包含横竖两个方向
		private var _scale:Point;
		private var _threshold:Point;
		
		// 位置相关
		private var _offset:Point;
		private var _origin:Point;
		private var _position:Point;
		
		// 速度相关
		private var _time:Number;
		private var _speed:Point;
		
		// 是否激活控件
		private var _enabled:Boolean;
		
		private var _tweenMode:Boolean = true;
		
		/**
		 * 构造函数
		 * create a [DragHelper] object
		 * @param	dragTarget	可以被拖动的那个交互对象
		 */
		public function DragHelper(dragTarget:InteractiveObject)
		{
			_target = dragTarget;
			
			if (!_target)
			{
				throw new ArgumentError("传入的InteractiveObject的对象不能为null");
			}
			
			_offset = new Point();
			_origin = new Point();
			_position = new Point();
			
			_speed = new Point();
			
			_scale = new Point(100, 100);
			_threshold = new Point(0.2, 0.2);
		}
		
		/**
		 * 添加事件侦听
		 */
		private function addListener():void
		{
			_target.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		private function removeListener():void
		{
			_target.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			if (_target.stage)
			{
				_target.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			}
		}
		
		/**
		 * 鼠标按下处理
		 * @param	e
		 */
		private function downHandler(e:MouseEvent):void 
		{
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			
			TweenLite.killTweensOf(_speed);
			
			_origin.x = _target.parent.mouseX;
			_origin.y = _target.parent.mouseY;
			
			_position.x = _origin.x;
			_position.y = _origin.y;
			
			_time = getTimer();
			
			dispatchEvent(new DragEvent(DragEvent.START_DRAG));
			
			_target.addEventListener(Event.ENTER_FRAME, frameHandler);
		}
		
		/**
		 * 鼠标弹起处理
		 * @param	e
		 */
		private function upHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			_target.removeEventListener(Event.ENTER_FRAME, frameHandler);
			
			_time = getTimer() - _time;
			
			_speed.x = (_position.x - _origin.x) / _time;
			_speed.y = (_position.y - _origin.y) / _time;
			
			if (Math.abs(_speed.x) < _threshold.x)_speed.x = 0;
			if (Math.abs(_speed.y) < _threshold.y)_speed.y = 0;
			
			_speed.x *= _scale.x;
			_speed.y *= _scale.y;
			
			dispatchEvent(new DragEvent(DragEvent.STOP_DRAG));
			
			if ((Math.abs(_speed.x) > 0 || Math.abs(_speed.y) > 0) && _tweenMode)
			{
				TweenLite.to(_speed, _duration, { x:0, y:0, ease:_ease, onComplete:complete, onUpdate:updateHandler }); return;
			}
			
			complete();
		}
		
		/**
		 * 更新处理
		 */
		private function updateHandler():void
		{
			_position.x += _speed.x;
			_position.y += _speed.y;
			
			_offset.x = _position.x - _origin.x;
			_offset.y = _position.y - _origin.y;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 
		 * @param	e
		 */
		private function frameHandler(e:Event = null):void 
		{
			_offset.x = _target.parent.mouseX - _origin.x;
			_offset.y = _target.parent.mouseY - _origin.y;
			
			_position.x = _origin.x + _offset.x;
			_position.y = _origin.y + _offset.y;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 拖动完成
		 */
		private function complete():void
		{
			dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE));
		}
		
		/**
		 * 速度放缩因子
		 * @default 100
		 */
		public function get scale():Point { return _scale; }
		public function set scale(value:Point):void 
		{
			_scale = value;
		}
		
		/**
		 * 拖动后停止所需要的时间
		 * @default 0.5
		 */
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void 
		{
			_duration = value;
		}
		
		/**
		 * 拖动后列表滚动所使用的缓动函数
		 * @default null
		 */
		public function get ease():Function { return _ease; }
		public function set ease(value:Function):void 
		{
			_ease = value;
		}
		
		/**
		 * 速度感应临界值
		 * @default 0.5
		 */
		public function get threshold():Point { return _threshold; }
		public function set threshold(value:Point):void 
		{
			_threshold = value;
		}
		
		/**
		 * 空间是否被激活
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			_enabled? addListener() : removeListener();
		}
		
		/**
		 * 坐标
		 */
		public function get offset():Point { return _offset; }		
		
		/**
		 * 缓动模式
		 */
		public function get tweenMode():Boolean { return _tweenMode; }
		public function set tweenMode(value:Boolean):void 
		{
			_tweenMode = value;
		}
	}

}