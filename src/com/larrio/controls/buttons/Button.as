package com.larrio.controls.buttons 
{
	import com.larrio.controls.wrappers.ButtonWrapper;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	
	/**
	 * 鼠标点击时派发
	 */
	[Event(name = "click", type = "flash.events.MouseEvent")]
	
	/**
	 * 鼠标滑过时派发
	 */
	[Event(name = "rollOver", type = "flash.events.MouseEvent")]
	
	/**
	 * 鼠标移开时派发
	 */
	[Event(name = "rollOut", type = "flash.events.MouseEvent")]
	
	/**
	 * 鼠标按下时派发
	 */
	[Event(name = "mouseDown", type = "flash.events.MouseEvent")]
	
	/**
	 * 鼠标弹起时派发
	 */
	[Event(name = "mouseUp", type = "flash.events.MouseEvent")]

	/**
	 * 按钮基类
	 * @author larryhou
	 */
	public class Button extends EventDispatcher
	{
		////////////////////////////////////////////////////////////////////
		// static members
		public static const ROLL_OUT:String = "out";
		public static const ROLL_OVER:String = "over";
		public static const MOUSE_DOWN:String = "down";
		public static const DISABLED:String = "disabled";
		
		////////////////////////////////////////////////////////////////////
		// private members
		
		protected var _buttonView:MovieClip;
		protected var _mouseEnabled:Boolean = false;
		
		private var _frameList:Array;
		private var _frameLabelPrefix:String = "";
		
		private var _disableStyle:BitmapFilter;
		
		/**
		 * 构造函数
		 * create a [Button] object
		 * @param	buttonView		按钮视图素材
		 * @param	useWrapper		是否使用包装器，如果buttonView不是MovieClip，则必须是用包装器
		 */
		public function Button(buttonView:DisplayObject, useWrapper:Boolean = false)
		{
			if (!buttonView)
			{
				throw new ArgumentError("构造" + this + "时必须传入有效的参数！");
			}
			
			if(useWrapper)
			{
				_buttonView = new ButtonWrapper(buttonView);
			}
			else
			{
				_buttonView = buttonView as MovieClip;
				_buttonView.mouseChildren = false;
			}
			
			init();
		}
		
		/**
		 * 初始化滤镜
		 */
		private function init():void
		{		
			recordFrames();
			
			var matrix:Array = [];
			matrix.push(0.309, 0.609, 0.082, 0.000, 0.000);
			matrix.push(0.309, 0.609, 0.082, 0.000, 0.000);
			matrix.push(0.309, 0.609, 0.082, 0.000, 0.000);
			matrix.push(0.000, 0.000, 0.000, 1.000, 0.000);
			
			_disableStyle = new ColorMatrixFilter(matrix);
		}
		
		/**
		 * 记录按钮帧标签
		 */
		private function recordFrames():void
		{
			_frameList = [];
			
			var scene:Scene = _buttonView.scenes[0];
			for each(var frameLable:FrameLabel in scene.labels)
			{
				_frameList.push(frameLable.name);
			}
		}
		
		/**
		 * 添加鼠标交互事件
		 */
		protected function addListener():void
		{
			_buttonView.mouseEnabled = _buttonView.buttonMode = true;
			_buttonView.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_buttonView.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			
			_buttonView.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		}
		
		/**
		 * 移除鼠标交互
		 */
		protected function removeListener():void
		{
			_buttonView.mouseEnabled = _buttonView.buttonMode = false;
			_buttonView.removeEventListener(MouseEvent.ROLL_OUT, outHandler);
			_buttonView.removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			_buttonView.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
			
			if (_buttonView.stage)
			{
				_buttonView.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
			}
		}
		
		/**
		 * 鼠标按下处理
		 * @param	e
		 */
		protected function downHandler(e:MouseEvent):void 
		{
			dispatchEvent(e);
			setButtonState(Button.MOUSE_DOWN);
			
			_buttonView.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		}
		
		/**
		 * 鼠标弹起处理
		 * @param	e
		 */
		protected function upHandler(e:MouseEvent):void 
		{
			e.currentTarget.removeEventListener(e.type, arguments.callee);
			
			dispatchEvent(e);
			
			if (_buttonView.contains(e.target as DisplayObject))
			{
				setButtonState(Button.ROLL_OVER);
				dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			else
			{				
				setButtonState(Button.ROLL_OUT);
			}
		}
		
		/**
		 * 鼠标滑过处理
		 * @param	e
		 */
		protected function overHandler(e:MouseEvent):void 
		{
			setButtonState(Button.ROLL_OVER);
		}
		
		/**
		 * 鼠标移开处理
		 * @param	e
		 */
		protected function outHandler(e:MouseEvent):void 
		{
			setButtonState(Button.ROLL_OUT);
		}
		
		/**
		 * 设置按钮状态
		 * @param	state
		 */
		protected function setButtonState(state:String):void
		{
			var frameLabel:String = state;
			
			_buttonView.filters = [];
			if (frameLabel == Button.DISABLED)
			{
				if (_frameList.indexOf(frameLabel) != -1)
				{
					_buttonView.gotoAndStop(frameLabel);
				}
				else
				{
					setButtonState(Button.ROLL_OUT);
					if(_disableStyle)
					{	
						_buttonView.filters = [_disableStyle];
					}
				}
				
				return;
			}
			
			if (_frameLabelPrefix)
			{
				frameLabel = _frameLabelPrefix + state.charAt(0).toUpperCase() + state.substr(1);
			}
			
			if (_frameList.indexOf(frameLabel) == -1) frameLabel = null;
			
			if(frameLabel)
			{
				_buttonView.gotoAndStop(frameLabel);
			}
		}
		
		/**
		 * 帧标签前缀
		 */
		public function get frameLabelPrefix():String { return _frameLabelPrefix; }
		public function set frameLabelPrefix(value:String):void 
		{
			if (value  == null)
			{
				value = "";
			}
			
			_frameLabelPrefix = value;
			setButtonState(Button.ROLL_OUT);
		}
		
		/**
		 * 是否激活按钮鼠标交互
		 */
		public function get mouseEnabled():Boolean {return _mouseEnabled;}
		public function set mouseEnabled(value:Boolean):void
		{
			_mouseEnabled = value;
			
			_buttonView.mouseEnabled = value;
			
			if (!_mouseEnabled)
			{
				removeListener();
				setButtonState(Button.DISABLED);
			}
			else
			{
				addListener();
				setButtonState(Button.ROLL_OUT);
			}
		}
		
		/**
		 * 是否可见
		 */
		public function get visible():Boolean { return _buttonView.visible; }
		public function set visible(value:Boolean):void 
		{
			_buttonView.visible = value;
		}
		
		/**
		 * 横坐标
		 */
		public function get x():Number { return _buttonView.x; }
		public function set x(value:Number):void 
		{
			_buttonView.x = value;
		}
		
		/**
		 * 竖坐标
		 */
		public function get y():Number { return _buttonView.y; }
		public function set y(value:Number):void 
		{
			_buttonView.y = value;
		}
		
		/**
		 * 按钮素材
		 */
		public function get buttonView():MovieClip {return _buttonView;}
		
		/**
		 * 宽度
		 */
		public function get width():Number {return _buttonView.width;}
		
		/**
		 * 高度
		 */
		public function get height():Number {return _buttonView.height;}

		/**
		 * 按钮mouseEnabled置为false时按钮的滤镜样式，默认为变灰
		 */		
		public function get disableStyle():BitmapFilter { return _disableStyle; }
		public function set disableStyle(value:BitmapFilter):void
		{
			_disableStyle = value;
		}

	}

}