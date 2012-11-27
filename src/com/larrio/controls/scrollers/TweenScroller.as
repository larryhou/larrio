package com.larrio.controls.scrollers
{
	import com.greensock.TweenLite;
	import com.larrio.controls.buttons.Button;
	import com.larrio.controls.events.ScrollEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	/**
	 * 包含两个按钮，滚动时整行、整列滚动
	 * @author larryhou
	 */
	public class TweenScroller extends SimpleScroller
	{	
		private var _skip:int;
		
		private var _delta:Number;
		private var _pageCount:int;
		private var _lineIndex:int;
		private var _scrolling:Boolean;
		
		private var _ease:Function;
		private var _duration:Number = 0.3;
		
		/**
		 * 构造函数
		 * create a [TweenScroller] object
		 * @param	preBtn		向上翻的按钮
		 * @param	nextBtn		向下翻的按钮
		 * @param	pageCount	滑块控制的列表需要显示的行数（竖直滚动）或者列数（水平滚动）
		 */
		public function TweenScroller(preBtn:DisplayObject, nextBtn:DisplayObject, pageCount:int)
		{
			super(preBtn, nextBtn);
			
			_pageCount = pageCount;
			
			this.skip = 1;
		}
		
		/**
		 * 鼠标按下处理
		 * @param	e
		 */
		override protected function downHandler(e:MouseEvent):void 
		{
			e.stopPropagation();
			
			if (_scrolling || _pageCount >= _lineCount) return;
			
			var _button:Button = e.currentTarget as Button;
			if (_button == _preBtn)
			{
				_directon = -1;
			}
			else
			{
				_directon = 1;
			}
			
			var _index:int = _lineIndex + _skip * _directon;
			if (_index >= _lineCount - _pageCount)
			{
				_index = _lineCount - _pageCount;
			}
			else
			if(_index <= 0)
			{
				_index = 0;
			}
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, _duration, { value: _index * _delta, ease:_ease, onUpdate:notify , onComplete:stopRenderer} );
			
			_scrolling = true;
			dispatchEvent(new ScrollEvent(ScrollEvent.START_SCROLLING));
		}
		
		/**
		 * 停止渲染
		 */
		private function stopRenderer():void
		{
			_scrolling = false;
			
			dispatchEvent(new ScrollEvent(ScrollEvent.STOP_SCROLLING));
		}
		
		// getter & setter
		//*************************************************
		/**
		 * 单次滚动的跳转的行数
		 * @default 1
		 */
		public function get skip():int { return _skip; }
		public function set skip(value:int):void
		{			
			_skip = Math.max(1, value);
		}
		
		/**
		 * 设置行数
		 */
		override public function set lineCount(value:int):void 
		{
			super.lineCount = value;
			
			_delta = 100 / (_lineCount - _pageCount);
		}
		
		/**
		 * 每次滚动所需要的时间
		 * @default 0.3
		 */
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void 
		{
			_duration = isNaN(value)? 0 : Math.max(0, value);
		}
		
		/**
		 * 缓动函数
		 * @default null
		 */
		public function get ease():Function { return _ease; }
		public function set ease(value:Function):void 
		{
			_ease = value;
		}
		
		/**
		 * 数值
		 * @default 0
		 */
		override public function set value(value:Number):void
		{			
			super.value = value;
			
			_lineIndex = Math.ceil(_value / _delta);
			
			if (_lineIndex >= _lineCount - _pageCount)
			{
				_preBtn.mouseEnabled = true;
				_nextBtn.mouseEnabled = false;
			}
			else
			if(_lineIndex <= 0)
			{
				_preBtn.mouseEnabled = false;
				_nextBtn.mouseEnabled = true;
			}
			else
			{
				_preBtn.mouseEnabled = true;
				_nextBtn.mouseEnabled = true;
			}
		}
	}

}