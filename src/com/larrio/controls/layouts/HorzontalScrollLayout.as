package com.larrio.controls.layouts
{
	import com.larrio.controls.wrappers.RenderWrapper;
	
	/**
	 * 水平方向矩阵列表布局控制类
	 * @author larryhou
	 */
	public class HorzontalScrollLayout extends ScrollLayout
	{	
		
		/**
		 * 构造函数
		 * create a [HorzontalScrollLayout] object
		 * @param	rowCount		每页显示的行数
		 * @param	columnCount		每页显示的列数
		 * @param	hgap			水平方向间隔
		 * @param	vgap			垂直方向间隔
		 */
		public function HorzontalScrollLayout(rowCount:int, columnCount:int = 1, hgap:int = 5, vgap:int = 5)
		{			
			super(rowCount, columnCount, hgap, vgap);
			
			_horizontalMode = true;
		}
		
		/**
		 * 滚动渲染
		 */
		override protected function scrollingRender():void
		{		
			// 开始渲染	
			var position:Number = _value * (_lineCount - _column) * (_itemWidth + _hgap) / 100;
			var columnIndex:Number = (position / (_itemWidth + _hgap)) >> 0;
			
			var scrollingRight:Boolean = (position < _scrollRect.x);
			
			_scrollRect.x = position;
			_container.scrollRect = _scrollRect;
			
			if (_lineIndex == columnIndex) 
			{
				_forceUpdate && layoutUpdate(); return;
			}
			
			if (Math.abs(_lineIndex - columnIndex) > 1)
			{
				_forceUpdate = true;
			}
			
			_lineIndex = columnIndex;
			
			swapItemOrder(scrollingRight);
		}
		
		/**
		 * 调整试图顺序
		 */
		override protected function swapItemOrder(scrollingRight:Boolean):void
		{
			var firstItem:RenderWrapper;
			var lastItem:RenderWrapper;
			
			var i:uint, j:uint;
			
			var index:int;
			if (scrollingRight)
			{
				for (index = 0; index < _row; index++)
				{
					firstItem = _items[0];
					lastItem = _items.pop() as RenderWrapper;
					
					lastItem.scrolling = _scrolling;
					lastItem.dataIndex = firstItem.dataIndex - 1;
					lastItem.data = _dataProvider[lastItem.dataIndex];
					
					j = lastItem.dataIndex / _row >> 0;
					i = lastItem.dataIndex % _row;
					lastItem.x = j * lastItem.width + j * _hgap;
					lastItem.y = i * lastItem.height + i * _vgap;
					lastItem.visible = lastItem.data != null;
					
					_items.unshift(lastItem);
				}
			}
			else
			{
				for (index = 0; index < _row; index++)
				{
					lastItem = _items[_items.length - 1];
					firstItem = _items.shift() as RenderWrapper;
					
					firstItem.scrolling = _scrolling;
					firstItem.dataIndex = lastItem.dataIndex + 1;
					firstItem.data = _dataProvider[firstItem.dataIndex];
					
					j = firstItem.dataIndex / _row >> 0;
					i = firstItem.dataIndex % _row;
					firstItem.x = j * firstItem.width + j * _hgap;
					firstItem.y = i * firstItem.height + i * _vgap;
					firstItem.visible = firstItem.data != null;
					
					_items.push(firstItem);
				}
			}
			
			_forceUpdate && super.swapItemOrder(scrollingRight);
		}
		
		/**
		 * 刷新显示
		 */
		override protected function layoutUpdate():void
		{
			var index:int, dataIndex:int;
			var data:Object, item:RenderWrapper;
			
			for (var i:int = _lineIndex; i < _lineIndex + _column + 1; i++)
			{
				for (var j:int = 0; j < _row; j++)
				{
					item = _items[index];
					dataIndex = i * _row + j;
					
					item.index = index;
					data = _dataProvider[dataIndex];
					
					if (_forceUpdate)
					{
						item.dataIndex = dataIndex;
						item.scrolling = _scrolling;
						
						item.data = data;
					}
					
					item.visible = data != null;
					
					item.y = j * item.height + j * _vgap;
					item.x = i * item.width + i * _hgap;
					index ++;
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
			var lineIndex:int = Math.floor(dataIndex / _row);
			if (lineIndex > (_lineCount - _column) && _lineCount > _column)
			{
				lineIndex = _lineCount - _column;
			}
			
			_forceUpdate = true;
			this.value = 100 * lineIndex / (_lineCount - _column);
		}
		
		/**
		 * 复写基类
		 */
		override public function set dataProvider(value:Array):void 
		{
			super.dataProvider = value;
			this.value = 100 * _lineIndex / (_lineCount - _column);
		}
	}

}