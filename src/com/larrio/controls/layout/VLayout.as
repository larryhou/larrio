package com.larrio.controls.layout 
{
	import com.larrio.controls.wrappers.RendererWrapper;
	
	/**
	 * 竖直方向布局
	 * @author larryhou
	 */
	public class VLayout extends BasicLayout
	{		
		/**
		 * 构造函数
		 * create a [VLayout] object
		 * @param	rowCount		每页显示的行数
		 * @param	columnCount		每页显示的列数
		 * @param	horizontalGap	水平方向间隔
		 * @param	verticalGap		垂直方向间隔
		 */
		public function VLayout(rowCount:int, columnCount:int = 1, horizontalGap:Number = 5, verticalGap:Number = 5)
		{			
			super(rowCount, columnCount, horizontalGap, verticalGap);
			
			_horizontalMode = false;
		}
		
		/**
		 * 滚动渲染
		 */
		override protected function startRenderer():void
		{		
			// 开始渲染
			var position:Number = _value * (_lineCount - _rowCount) * (_itemHeight + _verticalGap) / 100;
			
			var rowIndex:Number = (position / (_itemHeight + _verticalGap)) >> 0;
			
			var scrollingDown:Boolean = (position < _scrollRect.y);
			
			_scrollRect.y = position;
			_container.scrollRect = _scrollRect;
			
			if (_lineIndex == rowIndex) return;
			
			if (Math.abs(_lineIndex - rowIndex) > 1)
			{
				_forceUpdate = true;
			}
			
			_lineIndex = rowIndex;
			adjustItemViewOrder(scrollingDown);
		}
		
		/**
		 * 调整试图顺序
		 */
		override protected function adjustItemViewOrder(scrollingDown:Boolean):void
		{
			var index:int = 0;
			
			var lastItem:RendererWrapper = null;
			var firstItem:RendererWrapper = null;
			
			if (scrollingDown)
			{
				for (index = 0; index < _columnCount; index++)
				{
					firstItem = _itemList[0];
					lastItem = _itemList.pop() as RendererWrapper;
					lastItem.y = firstItem.y - _itemHeight - _verticalGap;
					
					lastItem.scrolling = _scrolling;
					lastItem.dataIndex = firstItem.dataIndex - 1;
					lastItem.data = _dataProvider[lastItem.dataIndex];
					
					_itemList.unshift(lastItem);
				}
			}
			else
			{
				for (index = 0; index < _columnCount; index++)
				{
					lastItem = _itemList[_itemList.length - 1];
					firstItem = _itemList.shift() as RendererWrapper;
					firstItem.y = lastItem.y + _itemHeight + _verticalGap;
					
					firstItem.scrolling = _scrolling;
					firstItem.dataIndex = lastItem.dataIndex + 1;
					firstItem.data = _dataProvider[firstItem.dataIndex];
					
					_itemList.push(firstItem);
				}
			}
			
			super.adjustItemViewOrder(scrollingDown);
		}
		
		/**
		 * 刷新显示
		 */
		override protected function refreshDisplay():void
		{
			var viewIndex:int = 0;
			var dataIndex:int = 0;
			var data:Object = null;
			var item:RendererWrapper = null;
			
			if (_lineIndex == 0)
			{
				_scrollRect.y = 0; _container.scrollRect = _scrollRect;
			}
			
			for (var i:int = _lineIndex; i < _lineIndex + _rowCount + 1; i++)
			{
				for (var j:int = 0; j < _columnCount; j++)
				{
					item = _itemList[viewIndex];
					dataIndex = i * _columnCount + j;
					
					item.index = viewIndex;
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
					
					item.x = j * item.width + j * _horizontalGap;
					item.y = i * item.height + i * _verticalGap;
					viewIndex ++;
				}
			}
			
			_forceUpdate = false;
		}
		
		/**
		 * 滚动到水平方向指定数据位置
		 * @param	dataIndex
		 */
		override public function scrollTo(dataIndex:int):void 
		{
			if (dataIndex < 0) dataIndex = 0;
			var lineIndex:int = Math.floor(dataIndex / _columnCount);
			if (lineIndex > (_lineCount - _rowCount) && _lineCount > _rowCount)
			{
				lineIndex = _lineCount - _rowCount;
			}
			
			_forceUpdate = true;
			this.value = 100 * lineIndex / (_lineCount - _rowCount);
		}
		
		/**
		 * 覆写基类
		 */
		override public function set dataProvider(value:Array):void 
		{
			super.dataProvider = value;
			
			_allowSameValue = true;
			this.value = 100 * (_lineIndex--) / (_lineCount - _rowCount);
			
		}
	}
}