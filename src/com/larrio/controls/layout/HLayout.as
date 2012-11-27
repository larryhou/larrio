package com.larrio.controls.layout
{
	import com.larrio.controls.wrappers.RendererWrapper;
	
	/**
	 * 水平方向矩阵列表布局控制类
	 * @author larryhou
	 */
	public class HLayout extends BasicLayout
	{	
		
		/**
		 * 构造函数
		 * create a [HLayout] object
		 * @param	rowCount		每页显示的行数
		 * @param	columnCount		每页显示的列数
		 * @param	horizontalGap	水平方向间隔
		 * @param	verticalGap		垂直方向间隔
		 */
		public function HLayout(rowCount:int, columnCount:int = 1, horizontalGap:Number = 5, verticalGap:Number = 5)
		{			
			super(rowCount, columnCount, horizontalGap, verticalGap);
			
			_horizontalMode = true;
		}
		
		/**
		 * 滚动渲染
		 */
		override protected function startRenderer():void
		{		
			// 开始渲染	
			var position:Number = _value * (_lineCount - _columnCount) * (_itemWidth + _horizontalGap) / 100;
			var columnIndex:Number = (position / (_itemWidth + _horizontalGap)) >> 0;
			
			var scrollingRight:Boolean = (position < _scrollRect.x);
			
			_scrollRect.x = position;
			_container.scrollRect = _scrollRect;
			
			if (_lineIndex == columnIndex) return;
			
			if (Math.abs(_lineIndex - columnIndex) > 1)
			{
				_forceUpdate = true;
			}
			
			_lineIndex = columnIndex;
			
			adjustItemViewOrder(scrollingRight);
		}
		
		/**
		 * 调整试图顺序
		 */
		override protected function adjustItemViewOrder(scrollingRight:Boolean):void
		{
			var index:int = 0;
			
			var firstItem:RendererWrapper = null;
			var lastItem:RendererWrapper = null;
			
			if (scrollingRight)
			{
				for (index = 0; index < _rowCount; index++)
				{
					firstItem = _itemList[0];
					lastItem = _itemList.pop() as RendererWrapper;
					lastItem.x = firstItem.x - _itemWidth - _horizontalGap;
					
					lastItem.scrolling = _scrolling;
					lastItem.dataIndex = firstItem.dataIndex - 1;
					lastItem.data = _dataProvider[lastItem.dataIndex];
					
					_itemList.unshift(lastItem);
				}
			}
			else
			{
				for (index = 0; index < _rowCount; index++)
				{
					lastItem = _itemList[_itemList.length - 1];
					firstItem = _itemList.shift() as RendererWrapper;
					firstItem.x = lastItem.x + _itemWidth + _horizontalGap;
					
					firstItem.scrolling = _scrolling;
					firstItem.dataIndex = lastItem.dataIndex + 1;
					firstItem.data = _dataProvider[firstItem.dataIndex];
					
					_itemList.push(firstItem);
				}
			}
			
			super.adjustItemViewOrder(scrollingRight);
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
				_scrollRect.x = 0; _container.scrollRect = _scrollRect;
			}
			
			for (var i:int = _lineIndex; i < _lineIndex + _columnCount + 1; i++)
			{
				for (var j:int = 0; j < _rowCount; j++)
				{
					item = _itemList[viewIndex];
					dataIndex = i * _rowCount + j;
					
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
					
					item.y = j * item.height + j * _verticalGap;
					item.x = i * item.width + i * _horizontalGap;
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
			var lineIndex:int = Math.floor(dataIndex / _rowCount);
			if (lineIndex > (_lineCount - _columnCount) && _lineCount > _columnCount)
			{
				lineIndex = _lineCount - _columnCount;
			}
			
			_forceUpdate = true;
			this.value = 100 * lineIndex / (_lineCount - _columnCount);
		}
		
		/**
		 * 复写基类
		 */
		override public function set dataProvider(value:Array):void 
		{
			super.dataProvider = value;
			
			_allowSameValue = true;
			this.value = 100 * (_lineIndex--) / (_lineCount - _columnCount);
		}
	}

}