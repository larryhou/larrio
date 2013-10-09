package com.larrio.controls.layouts
{
	import com.larrio.controls.interfaces.IRender;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 简单布局类
	 * @author larryhou
	 * @createTime 2012/6/6 16:53
	 */
	public class SimpleLayout extends Sprite
	{
		private var _row:uint;
		private var _column:uint;
		
		private var _hgap:Number;
		private var _vgap:Number;
		
		private var _dataProvider:Array;
		private var _itemRenderClass:Class;
		private var _items:Vector.<DisplayObject>;
		
		private var _forceUpdate:Boolean;
		
		private var _size:Rectangle;
		
		private var _bounds:Rectangle;
		
		/**
		 * 构造函数
		 * create a [SimpleLayout] object
		 */
		public function SimpleLayout(row:uint, column:uint, hgap:Number = 5, vgap:Number = 5) 
		{
			this.row = row;
			this.column = column;
			
			this.hgap = hgap;
			this.vgap = vgap;
			
			_size = new Rectangle();
			_items = new Vector.<DisplayObject>;
		}
		
		/**
		 * 渲染列表布局
		 */
		private function render():void
		{
			if (!_itemRenderClass)
			{
				throw new ArgumentError("itemRenderClass属性为null，布局控件崩溃orz...");
			}
			
			var length:uint = _dataProvider.length;
			if(_forceUpdate)	// 更新行列
			{
				if (!_row || !_column)
				{
					if (!_row)
					{
						_row = length / _column - 0.1 + 1 >> 0;
					}
					else
					{
						_column = Math.ceil(length / _row);
					}
				}
				
				_size.width = _size.height = 0;
			}
			
			var index:uint;
			var item:DisplayObject;
			
			var lineHeight:Number;
			var posY:Number = 0, posX:Number;
			for (var i:int = 0; i < _row; i++)
			{
				posX = 0; lineHeight = 0;
				for (var j:int = 0; j < _column; j++)
				{
					index = _column * i + j;
					if (!_dataProvider[index]) continue;
					
					if (index >= _items.length)
					{
						_items.push(new _itemRenderClass());
					}
					else
					if (Object(_items[index]).constructor != _itemRenderClass)
					{
						_items.push(_items[index]);
						_items[index] = new _itemRenderClass();
					}
					
					addChild(item = _items[index]);
					(item as IRender).data = _dataProvider[index];
					
					item.x = posX;
					item.y = posY;
					
					posX += item.width + _hgap;
					lineHeight = Math.max(item.height, lineHeight);
				}
				
				posY += lineHeight + _vgap;
				
				_size.width = Math.max(posX - _hgap, _size.width);
			}
			
			_size.height = posY - _vgap;
			
			if (!item) item = new _itemRenderClass();
			
			_bounds = new Rectangle();
			_bounds.width = (item.width + _hgap) * _column - _hgap;
			_bounds.height = (item.height + _vgap) * _row - _vgap;
			
			// 垃圾回收
			for (index = length; index < _items.length; index++)
			{
				item = _items[index];
				item.parent && item.parent.removeChild(item);
				if (Object(item).constructor != _itemRenderClass)
				{
					_items.splice(index--, 1);
					if (item.hasOwnProperty("dispose"))
					{
						item["dispose"]();
					}
				}
			}
		}
		
		/**
		 * 获取渲染器项目
		 * @param	index	渲染器对象位置
		 */
		public function getItemAt(index:uint):IRender
		{
			if (!_items || index >= _items.length) return null;
			return _items[index] as IRender;
		}
		
		// getter & setter
		//*************************************************
		/**
		 * 数据模型
		 */
		public function get dataProvider():Array { return _dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_dataProvider = value || [];
			
			render();
		}
		
		/**
		 * 行数
		 */
		public function get row():uint { return _row; }
		public function set row(value:uint):void 
		{
			_row = value;
			_forceUpdate = true;
		}
		
		/**
		 * 列数
		 */
		public function get column():uint { return _column; }
		public function set column(value:uint):void 
		{
			_column = value;
			_forceUpdate = true;
		}
		
		/**
		 * 横向间隔
		 */
		public function get hgap():Number { return _hgap; }
		public function set hgap(value:Number):void 
		{
			_hgap = isNaN(value)? 0 : value;
		}
		
		/**
		 * 竖向间隔
		 */
		public function get vgap():Number { return _vgap; }
		public function set vgap(value:Number):void 
		{
			_vgap = isNaN(value)? 0 : value;
		}
		
		/**
		 * 渲染器类
		 */
		public function get itemRenderClass():Class { return _itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			_itemRenderClass = value;
			this.dataProvider = null;
		}
		
		/**
		 * 布局高度
		 */
		override public function get height():Number { return _size.height; }
		override public function set height(value:Number):void { }
		
		/**
		 * 布局宽度
		 */
		override public function get width():Number { return _size.width; }
		override public function set width(value:Number):void { }
		
		/**
		 * 最大矩形框
		 */
		public function get bounds():Rectangle { return _bounds; }
		
	}

}