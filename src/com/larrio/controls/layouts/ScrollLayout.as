package com.larrio.controls.layouts 
{	
	import com.larrio.controls.interfaces.IComponent;
	import com.larrio.controls.wrappers.RenderWrapper;
	
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
	public class ScrollLayout extends Sprite implements IComponent
	{
		protected var _container:Sprite = null;
		
		protected var _row:int = 5;
		protected var _column:int = 1;
		
		protected var _enabled:Boolean = false;
		
		protected var _dataProvider:Array;
		protected var _itemRenderClass:Class;
		
		protected var _items:Array;
		
		protected var _lineIndex:int = 0;
		protected var _lineCount:int = 0;
		
		protected var _vgap:int;
		protected var _hgap:int;
		
		protected var _itemWidth:Number;
		protected var _itemHeight:Number;
		
		protected var _itemCount:int;
		protected var _dataIndex:int;
		
		protected var _scrolling:Boolean = false;
		protected var _forceUpdate:Boolean = false;
		
		protected var _value:Number = 0;
		protected var _horizontalMode:Boolean = false;
		
		protected var _scrollRect:Rectangle;
		
		/**
		 * 构造函数
		 * create a [ScrollLayout] object
		 * @param	rowCount		每页显示的行数
		 * @param	columnCount		每页显示的列数
		 * @param	hgap			水平方向间隔
		 * @param	vgap			垂直方向间隔
		 */
		public function ScrollLayout(rowCount:int, columnCount:int = 1, hgap:int = 5, vgap:int = 5)
		{	
			_row = rowCount;
			_column = columnCount;
			
			_hgap = hgap;
			_vgap = vgap;
			
			init();
		}
		
		/**
		 * 初始化设置
		 */		
		protected function init():void
		{
			addChild(_container = new Sprite());
			
			_scrollRect = new Rectangle();
		}
		
		/**
		 * 重置列表数据
		 */
		protected function resetView():void
		{
			var item:RenderWrapper;
			while (_items && _items.length)
			{
				item = _items.pop();
				item.parent && item.parent.removeChild(item);
				item.data = null;
			}
			
			if (_horizontalMode)
			{
				_itemCount = (_column + 1) * _row;
			}
			else
			{
				_itemCount = (_row + 1) * _column;
			}
			
			_items = [];
			for (var i:int = 0; i < _itemCount; i++)
			{
				item = new RenderWrapper(_itemRenderClass);
				item.visible = false;
				item.index = i;
				
				_items.push(_container.addChild(item));
			}
			
			_itemHeight = item.height;
			_itemWidth = item.width;
			
			// DisplayObject.scrollRect
			_scrollRect = new Rectangle();
			_scrollRect.width = _column * (_itemWidth + _hgap) - _hgap;
			_scrollRect.height = _row * (_itemHeight + _vgap) - _vgap;
			
			// 增强鼠标感应
			graphics.clear();
			graphics.beginFill(0xFF0000, 0);
			graphics.drawRect(0, 0, _scrollRect.width, _scrollRect.height);
			graphics.endFill();
			
			_container.scrollRect = _scrollRect;
		}
		
		/**
		 * 刷新当前页面数据
		 */		
		public function refresh():void
		{
			_forceUpdate = true;
			layoutUpdate();
		}
		
		//-----------------------------------------------------------
		//	protected APIs
		//-----------------------------------------------------------
		/**
		 * 滚动渲染
		 * @notice 需要基类复写实现
		 */
		protected function scrollingRender():void
		{
			
		}	
		
		/**
		 * 调整试图顺序
		 * @notice 需要基类复写实现
		 */
		protected function swapItemOrder(scrolling:Boolean):void
		{
			layoutUpdate();
		}
		
		/**
		 * 刷新显示
		 * @notice 需要基类复写实现
		 */
		protected function layoutUpdate():void
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
		protected function listen():void
		{
			
		}
		
		/**
		 * 移除事件侦听
		 */
		protected function unlisten():void
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
			
			_enabled? listen() : unlisten();
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
				_lineCount = Math.ceil(_dataProvider.length / _row);
				_lineIndex = Math.min(_lineIndex, _lineCount - _column);
			}
			else
			{
				_lineCount = Math.ceil(_dataProvider.length / _column);
				_lineIndex = Math.min(_lineIndex, _lineCount - _row);
			}
			
			_lineIndex = Math.max(_lineIndex, 0);
			
			if (!_items || !_items.length)
			{
				resetView();
			}
		}
		
		/**
		 * ListItem渲染类，该类为BasicItem的子类
		 */
		public function get itemRenderClass():Class { return _itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			_itemRenderClass = value;
			if (_dataProvider)
			{
				_forceUpdate = true;
				
				resetView();
				this.value = _value;
			}
			else
			{
				this.dataProvider = null;
			}
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
				flag = (_lineCount <= _column);
			}
			else
			{
				flag = (_lineCount <= _row);
			}
			
			if (flag)
			{
				_lineIndex = 0;
				layoutUpdate();
			}
			else
			{
				scrollingRender();
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

		/**
		 * 列表行数
		 */		
		public function get row():int { return _row; }
		public function set row(value:int):void
		{
			if (value == _row) return;
			
			var index:uint = _lineIndex * _column;
			if (_horizontalMode)
			{
				index = _lineIndex * _row;
			}
			
			_row = value;
			
			resetView();
			this.dataProvider = _dataProvider;
			
			scrollTo(index);
		}

		/**
		 * 布局列表列数
		 */		
		public function get column():int { return _column; }
		public function set column(value:int):void
		{
			if (value == _column) return;
			
			var index:uint = _lineIndex * _column;
			if (_horizontalMode)
			{
				index = _lineIndex * _row;
			}
			
			_column = value;
			
			resetView();
			this.dataProvider = _dataProvider;
			
			scrollTo(index);
		}

		/**
		 * 设置竖向间隔
		 */		
		public function get vgap():int { return _vgap; }
		public function set vgap(value:int):void
		{
			_vgap = value; 
			_scrollRect.height = _row * (_itemHeight + _vgap) - _vgap;
			_container.scrollRect = _scrollRect;
			
			layoutUpdate();
		}

		/**
		 * 设置横向间隔
		 */		
		public function get hgap():int { return _hgap; }
		public function set hgap(value:int):void
		{
			_hgap = value; 
			_scrollRect.width = _column * (_itemWidth + _hgap) - _hgap;
			_container.scrollRect = _scrollRect;
			
			layoutUpdate();
		}
	}

}