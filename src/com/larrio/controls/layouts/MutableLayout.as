package com.larrio.controls.layouts 
{
	import com.larrio.controls.interfaces.IMutableRender;
	import com.larrio.controls.interfaces.IRender;
	import com.larrio.controls.wrappers.RenderWrapper;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 变高度渲染器列表
	 * @author larryhou
	 * @createTime 2014/6/30 16:10
	 */
	public class MutableLayout extends Sprite
	{
		private var _container:Sprite;
		
		private var _recycleItems:Vector.<RenderWrapper>;
		private var _items:Vector.<RenderWrapper>;
		
		private var _viewport:Rectangle;
		private var _gap:Number;
		
		private var _itemRenderClass:Class;
		private var _dataProvider:Array;
		
		private var _renderTotalHeight:Number;
		private var _value:Number;
		
		private var _ranges:Dictionary;
		private var _scrollable:Boolean;
		
		private var _rememberPosition:Boolean;
		
		private var _background:Shape;
		
		/**
		 * 构造函数
		 * create a [MutableLayout] object
		 */
		public function MutableLayout(width:uint, height:uint, gap:Number = 5)
		{
			_gap = 5;
			_viewport = new Rectangle(0, 0, width, height);
			
			_items = new Vector.<RenderWrapper>();
			_recycleItems = new Vector.<RenderWrapper>();
			
			_container = new Sprite();
			_container.scrollRect = _viewport;
			addChild(_container);
			
			_background = new Shape();
			_background.graphics.beginFill(0, 0);
			_background.graphics.drawRect(0, 0, width, height);
			addChild(_background);
			
			_dataProvider = [];
		}
		
		// private methods
		//*************************************************
		/**
		 * 初始化显示列表
		 */
		private function resetView():void
		{
			if (_dataProvider.length)
			{
				if (!_rememberPosition)
				{
					_viewport.y = 0;
					_container.scrollRect = _viewport;
					_value = 0;
				}	
				
				var index:int = locateItemAt(_viewport.y);
				fillUpLayout(Math.max(0, index));
			}
			else
			{
				while (_items.length)
				{
					reclaimItem(_items.pop());
				}
			}
		}
		
		/**
		 * 在列表视野中铺满渲染器
		 * @param	index	渲染器起始索引
		 */
		private function fillUpLayout(index:uint):void
		{
			if (!_dataProvider.length) return;
			
			var range:HeightRange = _ranges[_dataProvider[index]] as HeightRange;
			var position:Number = range.lower;
			
			var item:RenderWrapper;
			var viewIndex:uint;
			
			do
			{
				if (viewIndex < _items.length)
				{
					item = _items[viewIndex];
				}
				else
				{
					item = createRenderItem();
					
					_container.addChild(item);
					_items.push(item);
				}
				
				item.y = position;
				item.dataIndex = index;
				item.data = _dataProvider[item.dataIndex];
				position += item.height + _gap;
				
				viewIndex++;
				index++;
				
			} while (position - _viewport.y < _viewport.height && index < _dataProvider.length)
			
			while (viewIndex < _items.length)
			{
				reclaimItem(_items.pop());
			}
		}
		
		/**
		 * 回收复用渲染器项目
		 * @param	item	渲染器项目
		 */
		private function reclaimItem(item:RenderWrapper):RenderWrapper
		{
			item.parent && item.parent.removeChild(item);
			//if (_recycleItems.indexOf(item) < 0)
			//{
				_recycleItems.push(item);
			//}
			
			return item;
		}
		
		/**
		 * 滚动渲染
		 */
		private function scrollingRender():void
		{
			if (!_dataProvider.length) return;
			
			var position:Number = _value * Math.max(0, _renderTotalHeight - _viewport.height) / 100;
			var scrollingDown:Boolean = position > _viewport.y;
			
			_viewport.y = position;
			_container.scrollRect = _viewport;
			
			var item:RenderWrapper, refer:RenderWrapper;
			if (!scrollingDown)
			{
				// 移除下面已经超出视野的渲染器
				while (_items.length)
				{
					item = _items[_items.length - 1];
					if (item.y - _gap - _viewport.y > _viewport.height)
					{
						reclaimItem(_items.pop());
					}
					else
					{
						break;
					}
				}
				
				_items.length == 0 && makeSafeLayout();
				
				refer = _items[0]; // 填充上面空白的项目
				while (refer.y - _gap - _viewport.y > 0 && refer.dataIndex - 1 >= 0) 
				{
					item = createRenderItem();
					item.dataIndex = refer.dataIndex - 1;
					item.data = _dataProvider[item.dataIndex];
					item.y = refer.y - _gap - item.height;
					
					_container.addChild(item);
					_items.unshift(refer = item);
				}
			}
			else
			{
				// 移除上面已经超出视野的渲染器
				while (_items.length)
				{
					item = _items[0];
					if (item.y + item.height - _viewport.y < 0)
					{
						reclaimItem(_items.shift());
					}
					else
					{
						break;
					}
				}
				
				_items.length == 0 && makeSafeLayout();
				
				refer = _items[_items.length - 1]; // 填充下面空白的项目
				while (refer.y + refer.height + _gap - _viewport.y < _viewport.height && refer.dataIndex + 1 < _dataProvider.length)
				{
					item = createRenderItem();
					item.dataIndex = refer.dataIndex + 1;
					item.data = _dataProvider[item.dataIndex];
					item.y = refer.y + refer.height + _gap;
					
					_container.addChild(item);
					_items.push(refer = item);
				}
			}
		}
		
		/**
		 * 无渲染器显示时修复
		 */
		private function makeSafeLayout():void
		{
			var index:int = locateItemAt(_viewport.y);
			if (index >= 0)
			{
				fillUpLayout(index);
			}
			else
			{
				throw new Error("数据维护异常");
			}
		}
		
		/**
		 * 创建渲染器对象
		 */
		private function createRenderItem():RenderWrapper
		{
			if (_recycleItems.length)
			{
				return _recycleItems.pop();
			}
			
			return new RenderWrapper(_itemRenderClass);
		}
		
		// public methods
		//*************************************************
		/**
		 * 滚动到制定索引位置
		 * @param	dataIndex	数据索引
		 */
		public function scrollTo(dataIndex:uint, appearAtBottom:Boolean = true):void
		{
			if (_renderTotalHeight > _viewport.height)
			{
				this.value = 100 * getItemPosition(dataIndex, appearAtBottom) / (_renderTotalHeight - _viewport.height);
			}
		}
		
		/**
		 * 刷新渲染器展示
		 */
		public function refresh():void
		{
			var item:RenderWrapper;
			for (var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				item.data = _dataProvider[item.dataIndex];
			}
		}
		
		/**
		 * 获取已显示的渲染器
		 * @param	index	渲染器显示索引：从上到下递增
		 */
		public function getItemAt(index:uint):IMutableRender
		{
			if (index < _items.length)
			{
				return _items[index].target as IMutableRender;
			}
			
			return null;
		}
		
		/**
		 * 获取鼠标下渲染器对象
		 */
		public function getItemUnderMouse():IMutableRender
		{
			var rect:Rectangle;
			var item:RenderWrapper;
			for (var i:int = 0; i < _items.length; i++)
			{
				item = _items[i];
				rect = item.getBounds(this);
				if (rect.contains(mouseX, mouseY))
				{
					return item.target as IMutableRender;
				}
			}
			
			return null;
		}
		
		/**
		 * 获取指定数据对应坐标位置
		 * @param	dataIndex	数据索引
		 * @return	如果返回为NaN则表示对应数据不存在
		 */
		public function getItemPosition(dataIndex:uint, appearAtBottom:Boolean = true):Number
		{
			dataIndex = Math.min(dataIndex, _dataProvider.length - 1);
			if (_dataProvider.length)
			{
				var range:HeightRange = _ranges[_dataProvider[dataIndex]] as HeightRange;
				return appearAtBottom? (range.upper - _viewport.height) : range.lower;
			}
			
			return 0;
		}
		
		/**
		 * 正在显示的渲染器高度变更时更新渲染
		 * @param	data	渲染器数据
		 */
		public function renderAfterHeightChange(data:Object):void
		{
			var range:HeightRange = _ranges[data] as HeightRange;
			if (range)
			{
				collectRenderHeights();
				
				var flag:Boolean = false;
				if (range.lower > _viewport.y && range.lower < _viewport.bottom)
				{
					flag = true;
				}
				
				if (range.upper > _viewport.y && range.upper < _viewport.bottom)
				{
					flag = true;
				}
				
				flag && makeSafeLayout();
			}
		}
		
		/**
		 * 垃圾回收
		 */
		public function dispose():void
		{
			var list:Vector.<RenderWrapper> = _items.concat(_recycleItems);
			
			var item:RenderWrapper;
			while (list.length) 
			{
				item = list.pop();
				item.parent && item.parent.removeChild(item);
				item.dispose();
			}
			
			_recycleItems.length = 0;
			_items.length = 0;
			
			_dataProvider = null;
			_ranges = null;
		}
		
		// private methods
		//*************************************************
		/**
		 * 更新渲染器高度数据
		 */
		private function collectRenderHeights():void
		{
			_renderTotalHeight = 0;
			_ranges = new Dictionary(false);
			
			var ghost:IMutableRender = new _itemRenderClass();
			
			var data:Object, range:HeightRange;
			
			var length:uint = _dataProvider.length;
			for (var i:int = 0; i < length; i++)
			{
				range = new HeightRange();
				range.lower = _renderTotalHeight;
				
				data = _dataProvider[i];
				
				_ranges[data] = range;
				_renderTotalHeight += ghost.caculateHeight(_dataProvider[i]);
				_renderTotalHeight += _gap;
				
				range.upper = _renderTotalHeight;
			}
			
			_scrollable = _renderTotalHeight > _viewport.height;
			
			const DISPOSE_FUNC_NAME:String = "dispose";
			if (DISPOSE_FUNC_NAME in ghost)
			{
				if (ghost[DISPOSE_FUNC_NAME] is Function) 
				{
					(ghost[DISPOSE_FUNC_NAME] as Function).call();
				}
			}
		}
		
		/**
		 * 定位某个位置
		 * @param	value	竖向坐标
		 */
		private function locateItemAt(value:Number):int
		{
			return _dataProvider.length? iterateSearch(value, 0, _dataProvider.length) : -1;
		}
		
		/**
		 * 迭代搜索指定坐标下的渲染器数据索引
		 */
		private function iterateSearch(value:Number, left:uint, right:uint):int
		{
			var result:int;
			
			var index:uint = left + right >> 1;
			var range:HeightRange = _ranges[_dataProvider[index]] as HeightRange;
			
			if (range.lower > value)
			{
				if(index < right)
				{
					right = index;
					result = iterateSearch(value, left, right);
				}
				else
				{
					result = -1;
				}
			}
			else
			if (range.upper <= value)
			{
				if (index > left)
				{
					left = index;
					result = iterateSearch(value, left, right);
				}
				else
				{
					result = -1;
				}
			}
			else
			{
				result = index;
			}
			
			return result;
		}
		
		// getters & setters
		//*************************************************
		/**
		 * 复写列表可视宽度
		 */
		override public function get width():Number { return _viewport.width; }
		override public function set width(value:Number):void 
		{ 
			_viewport = new Rectangle(_viewport.x, _viewport.y, value, _viewport.height);
			_container.scrollRect = _viewport;
			_background.width = value;
			
			scrollingRender();
		}
		
		/**
		 * 复写列表可视高度
		 */
		override public function get height():Number { return _viewport.height; }
		override public function set height(value:Number):void 
		{ 
			_viewport = new Rectangle(_viewport.x, _viewport.y, _viewport.width, value);
			_container.scrollRect = _viewport;
			_background.height = value;
			
			scrollingRender();
		}
		
		/**
		 * 数值驱动器
		 */
		public function get value():Number { return _value; }
		public function set value(value:Number):void 
		{
			_value = isNaN(value)? 0 : Math.max(0, Math.min(100, value));
			scrollingRender();
		}
		
		/**
		 * 列表数据
		 */
		public function get dataProvider():Array { return _dataProvider ||= []; }
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value || [];
			
			collectRenderHeights();
			resetView();
		}
		
		/**
		 * 渲染器类
		 */
		public function get itemRenderClass():Class { return _itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			if (value != _itemRenderClass)
			{
				var item:RenderWrapper;
				var list:Vector.<RenderWrapper> = _items.concat(_recycleItems);
				while (list.length)
				{
					item = list.pop();
					item.parent && item.parent.removeChild(item);
					item.dispose();
				}
				
				_items.length = 0;
				_recycleItems.length = 0;
			}
			
			_itemRenderClass = value;
			if (_dataProvider.length)
			{
				this.dataProvider = _dataProvider;
			}
		}
		
		/**
		 * 像素位置
		 */
		public function get position():Number { return _viewport.y; }
		public function set position(value:Number):void 
		{
			value = isNaN(value)? 0 : Math.max(0, value);
			this.value = 100 * value / (_renderTotalHeight - _viewport.height);
		}
		
		/**
		 * 布局中第一个渲染器的数据索引
		 */
		public function get currentIndex():int { return _items.length? _items[0].dataIndex : -1; }
		
		/**
		 * 当前列表是否处于可滚动状态
		 */
		public function get scrollable():Boolean { return _scrollable; }
		
		/**
		 * 当前页显示渲染器个数
		 */
		public function get pageCount():uint { return _items.length; }
		
		/**
		 * 自动记忆位置
		 * @usage 在设置dataProvider属性时，可以自动恢复设置前的滚动位置
		 */
		public function get rememberPosition():Boolean { return _rememberPosition; }
		public function set rememberPosition(value:Boolean):void 
		{
			_rememberPosition = value;
		}
	}
}

// 半闭合区间
// upper > x >= lower
class HeightRange
{
	/**
	 * 区间上限：不包含
	 */
	public var upper:Number;
	
	/**
	 * 区间下限：包含
	 */
	public var lower:Number;
}