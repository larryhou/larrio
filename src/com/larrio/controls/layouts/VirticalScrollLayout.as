package com.larrio.controls.layouts 
{
	import com.larrio.controls.wrappers.RenderWrapper;
	
	/**
	 * 竖直方向布局
	 * @author larryhou
	 */
	public class VirticalScrollLayout extends ScrollLayout
	{		
		/**
		 * 构造函数
		 * create a [VirticalScrollLayout] object
		 * @param	rowCount		每页显示的行数
		 * @param	columnCount		每页显示的列数
		 * @param	hgap			水平方向间隔
		 * @param	vgap			垂直方向间隔
		 */
		public function VirticalScrollLayout(rowCount:int, columnCount:int = 1, hgap:int = 5, vgap:int = 5)
		{			
			super(rowCount, columnCount, hgap, vgap);
			
			_horizontalMode = false;
		}
		
		/**
		 * 滚动渲染
		 */
		override protected function scrollingRender():void
		{		
			// 开始渲染
			var position:Number = _value * (_lineCount - _row) * (_itemHeight + _vgap) / 100;
			
			var rowIndex:Number = (position / (_itemHeight + _vgap)) >> 0;
			
			var scrollingDown:Boolean = (position < _scrollRect.y);
			
			_scrollRect.y = position;
			_container.scrollRect = _scrollRect;
			
			if (_lineIndex == rowIndex) return;
			
			if (Math.abs(_lineIndex - rowIndex) > 1)
			{
				_forceUpdate = true;
			}
			
			_lineIndex = rowIndex;
			swapItemOrder(scrollingDown);
		}
		
		/**
		 * 调整试图顺序
		 */
		override protected function swapItemOrder(scrollingDown:Boolean):void
		{
			var lastItem:RenderWrapper;
			var firstItem:RenderWrapper;
			
			var index:int;
			if (scrollingDown)
			{
				for (index = 0; index < _column; index++)
				{
					firstItem = _items[0];
					lastItem = _items.pop() as RenderWrapper;
					lastItem.y = firstItem.y - _itemHeight - _vgap;
					
					lastItem.scrolling = _scrolling;
					lastItem.dataIndex = firstItem.dataIndex - 1;
					lastItem.data = _dataProvider[lastItem.dataIndex];
					
					_items.unshift(lastItem);
				}
			}
			else
			{
				for (index = 0; index < _column; index++)
				{
					lastItem = _items[_items.length - 1];
					firstItem = _items.shift() as RenderWrapper;
					firstItem.y = lastItem.y + _itemHeight + _vgap;
					
					firstItem.scrolling = _scrolling;
					firstItem.dataIndex = lastItem.dataIndex + 1;
					firstItem.data = _dataProvider[firstItem.dataIndex];
					
					_items.push(firstItem);
				}
			}
			
			super.swapItemOrder(scrollingDown);
		}
		
		/**
		 * 刷新显示
		 */
		override protected function layoutUpdate():void
		{
			var index:int, dataIndex:int;
			var data:Object, item:RenderWrapper;
			
			if (_lineIndex == 0)
			{
				_scrollRect.y = 0; _container.scrollRect = _scrollRect;
			}
			
			for (var i:int = _lineIndex; i < _lineIndex + _row + 1; i++)
			{
				for (var j:int = 0; j < _column; j++)
				{
					item = _items[index];
					dataIndex = i * _column + j;
					
					item.index = index;
					data = _dataProvider[dataIndex];
					
					if (_forceUpdate)
					{
						item.dataIndex = dataIndex;						
						item.scrolling = _scrolling;
						
						item.data = data;
					}
					
					// check
					if (data)
					{
						if(item.parent != _container)
						{
							_container.addChild(item);
						}
					}
					else
					{
						item.parent && item.parent.removeChild(item);
					}
					
					item.x = j * item.width + j * _hgap;
					item.y = i * item.height + i * _vgap;
					index ++;
				}
			}
			
			_forceUpdate = false;
		}
		
		/**
		 * 滚动到水平方向指定数据位置
		 * @param	dataIndex	数据索引
		 */
		override public function scrollTo(dataIndex:int):void 
		{
			if (dataIndex < 0) dataIndex = 0;
			var lineIndex:int = Math.floor(dataIndex / _column);
			if (lineIndex > (_lineCount - _row) && _lineCount > _row)
			{
				lineIndex = _lineCount - _row;
			}
			
			_forceUpdate = true;
			this.value = 100 * lineIndex / (_lineCount - _row);
		}
		
		/**
		 * 覆写基类
		 */
		override public function set dataProvider(value:Array):void 
		{
			super.dataProvider = value;
			this.value = 100 * (_lineIndex--) / (_lineCount - _row);
		}
	}
}