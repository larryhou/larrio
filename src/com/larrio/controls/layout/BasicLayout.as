package com.larrio.controls.layout 
{	
	import com.larrio.controls.interfaces.IController;
	import com.larrio.controls.wrappers.RendererWrapper;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 列表滚动时派发
	 */
	[Event(name = "change", type = "flash.events.Event")]
	
	/**
	 * 列表停止滚动时派发
	 */
	[Event(name = "stopScrolling",type = "com.larrio.controls.events.ScrollEvent")]
	
	/**
	 * 列表开始滚动时派发
	 */
	[Event(name = "startScrolling",type = "com.larrio.controls.events.ScrollEvent")]
	
	/**
	 * 滚动列表基类
	 * @author larryhou
	 */
	public class BasicLayout extends Sprite implements IController
	{
		protected var _container:Sprite = null;
		
		protected var _rowCount:int = 5;
		protected var _columnCount:int = 1;
		
		protected var _enabled:Boolean = false;
		
		protected var _dataProvider:Array;
		protected var _itemRenderClass:Class;
		
		protected var _itemList:Array = null;
		
		protected var _lineIndex:int = 0;
		protected var _lineCount:int = 0;
		
		protected var _verticalGap:Number;
		protected var _horizontalGap:Number;
		
		protected var _itemWidth:Number;
		protected var _itemHeight:Number;
		
		protected var _itemCount:int;
		protected var _dataIndex:int;
		
		protected var _scrolling:Boolean = false;
		protected var _forceUpdate:Boolean = false;
		
		protected var _value:Number = 0;
		protected var _horizontalMode:Boolean = false;
		
		protected var _scrollRect:Rectangle;
		protected var _allowSameValue:Boolean = false;
		
		/**
		 * 构造函数
		 * create a [BasicLayout] object
		 * @param	rowCount		每页显示的行数
		 * @param	columnCount		每页显示的列数
		 * @param	horizontalGap	水平方向间隔
		 * @param	verticalGap		垂直方向间隔
		 */
		public function BasicLayout(rowCount:int, columnCount:int = 1, horizontalGap:Number = 5, verticalGap:Number = 5)
		{	
			_rowCount = rowCount;
			_columnCount = columnCount;
			
			_horizontalGap = horizontalGap;
			_verticalGap = verticalGap;
			
			_container = new Sprite();
			_container.name = "item_renderer_container";
			
			addChild(_container);
			this.name = "layout_contrainer";
		}
		
		/**
		 * 初始化列表
		 */
		protected function initView():void
		{
			_itemList = [];
			
			if (_horizontalMode)
			{
				_itemCount = (_columnCount + 1) * _rowCount;
			}
			else
			{
				_itemCount = (_rowCount + 1) * _columnCount;
			}
			
			var itemRender:RendererWrapper = null;
			for (var i:int = 0; i < _itemCount; i++)
			{
				itemRender = new RendererWrapper(_itemRenderClass);
				itemRender.index = i;
				_itemList.push(itemRender);
			}
			
			_itemHeight = itemRender.height;
			_itemWidth = itemRender.width;
			
			// scroll rect
			_scrollRect = new Rectangle();
			_scrollRect.width = _columnCount * (_itemWidth + _horizontalGap) - _horizontalGap;
			_scrollRect.height = _rowCount * (_itemHeight + _verticalGap) - _verticalGap;
			
			// add transparent mouse interact area
			var g:Graphics = this.graphics;
			
			g.beginFill(0xFF0000, 0);
			g.drawRect(0, 0, _scrollRect.width, _scrollRect.height);
			g.endFill();
			
			_container.scrollRect = _scrollRect;
		}
		
		//-----------------------------------------------------------
		//	protected APIs
		//-----------------------------------------------------------
		/**
		 * 滚动渲染
		 * @notice 需要基类复写实现
		 */
		protected function startRenderer():void
		{
			
		}	
		
		/**
		 * 调整试图顺序
		 * @notice 需要基类复写实现
		 */
		protected function adjustItemViewOrder(scrolling:Boolean):void
		{
			refreshDisplay();
		}
		
		/**
		 * 刷新显示
		 * @notice 需要基类复写实现
		 */
		protected function refreshDisplay():void
		{
			
		}
		
		/**
		 * 滚动到指定数据位置
		 * @param	dataIndex
		 */
		public function scrollTo(dataIndex:int):void
		{
			
		}
		
		/**
		 * 添加事件侦听
		 */
		protected function addListener():void
		{
			
		}
		
		/**
		 * 移除事件侦听
		 */
		protected function removeListener():void
		{
			
		}
		
		// getter & setter
		//*************************************************
		/**
		 * 是否激活鼠标交互
		 * @default false
		 * @important 如需正常使用，需要把该属性设为true
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			_enabled? addListener() : removeListener();
		}
		
		/**
		 * 数据
		 */
		public function get dataProvider():Array { return _dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_forceUpdate = true;
			_dataProvider = value || [];
			
			if (_horizontalMode)
			{
				_lineCount = Math.ceil(_dataProvider.length / _rowCount);
				_lineIndex = Math.min(_lineIndex, _lineCount - _columnCount);
			}
			else
			{
				_lineCount = Math.ceil(_dataProvider.length / _columnCount);
				_lineIndex = Math.min(_lineIndex, _lineCount - _rowCount);
			}
			
			_lineIndex = Math.max(_lineIndex, 0);
			
			if (!_itemList)
			{
				initView();
			}
		}
		
		/**
		 * ListItem渲染类，该类为BasicItem的子类
		 */
		public function get itemRenderClass():Class { return _itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			_itemRenderClass = value;
			
			this.dataProvider = null;
		}
		
		/**
		 * 滚动列表宽度
		 */
		override public function get width():Number { return _scrollRect.width; }
		
		/**
		 * 滚动列表高度
		 */
		override public function get height():Number { return _scrollRect.height; }
		
		/**
		 * 当前列表滚动位置
		 */
		public function get value():Number { return _value; }
		public function set value(value:Number):void
		{
			if (isNaN(value)) value = 0;
			value = Math.max(0, Math.min(100, value));
			
			if (_value == value && !_forceUpdate) return;
			
			_value = value;
			
			var flag:Boolean = false;
			if (_horizontalMode)
			{
				flag = (_lineCount <= _columnCount);
			}
			else
			{
				flag = (_lineCount <= _rowCount);
			}
			
			if (flag)
			{
				_lineIndex = 0;
				refreshDisplay();
			}
			else
			{
				startRenderer();
			}
		}
		
		/**
		 * 列表是否正在滚动
		 */
		public function get scrolling():Boolean { return _scrolling; }
		public function set scrolling(value:Boolean):void
		{
			_scrolling = value;
		}
		
		/**
		 * 行数或者列数
		 */
		public function get lineCount():int { return _lineCount; }
		public function set lineCount(value:int):void 
		{
			_lineCount = value;
		}
		
		/**
		 * 强制更新列表显示
		 * @notice	如果运算layout.value = layout.value，则需要设置该值为true，否则列表不会更新
		 */
		public function get forceUpdate():Boolean { return _forceUpdate; }
		public function set forceUpdate(value:Boolean):void 
		{
			_forceUpdate = value;
		}
	}

}