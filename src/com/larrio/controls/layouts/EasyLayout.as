package com.larrio.controls.layouts 
{
	import com.larrio.controls.scrollers.bar.BarView;
	import com.larrio.controls.interfaces.IComponent;
	import com.larrio.controls.interfaces.IScroller;
	import com.larrio.controls.scrollers.ScrollBar;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 常用布局控制类
	 * @author larryhou
	 * @createTime 2012/5/29 12:03
	 */
	public class EasyLayout extends EventDispatcher implements IComponent
	{
		private var _scroller:IScroller;
		private var _layout:ScrollLayout;
		
		private var _enabled:Boolean;
		private var _virtical:Boolean;
		
		/**
		 * 构造函数
		 * create a [EasyLayout] object
		 */
		public function EasyLayout(row:int, column:int = 1, hgap:Number = 5, vgap:Number = 5, virtical:Boolean = true, scroller:IScroller = null) 
		{
			_scroller = scroller;
			_virtical = virtical;
			
			if (_virtical)
			{
				_layout = new VirticalScrollLayout(row, column, hgap, vgap);
			}
			else
			{
				_layout = new HorzontalScrollLayout(row, column, hgap, vgap);
			}
			
			if (!_scroller) 
			{
				_scroller = new ScrollBar(new BarView(), _virtical? row : column);
				_layout.addChild((_scroller as ScrollBar).view);
			}
			
			if (_scroller is ScrollBar)
			{
				(_scroller as ScrollBar).wheelArea = _layout;
			}
		}
		
		/**
		 * 滚动列表到指定数据位置
		 * @param	dataIndex	数据索引
		 */
		public function scrollTo(dataIndex:int):void
		{
			_layout.scrollTo(dataIndex);
			
			_scroller.value = _layout.value;
		}
		
		/**
		 * 刷新显示
		 */
		private function refresh():void
		{
			if(_scroller is ScrollBar && (_scroller as ScrollBar).view is BarView)
			{
				var bar:ScrollBar = _scroller as ScrollBar;
				if(_virtical)
				{
					bar.view.rotation = 0;
					bar.view.x = _layout.width;
					bar.height = _layout.height;
					
					if (bar.view is BarView)
					{
						bar.view.y = 1;
						bar.view.x += 2;
						bar.view.height -= 2;
					}
				}
				else
				{
					bar.view.y = _layout.height;
					bar.height = _layout.width;
					
					if (bar.view is BarView)
					{
						bar.view.x = 1;
						bar.view.y += 2 + bar.width;
						bar.height -= 2;
					}
					
					bar.view.rotation = -90;
				}
			}
		}
		
		/**
		 * 添加事件侦听
		 */
		private function listen():void
		{
			_layout.addEventListener(Event.CHANGE, changeHandler);
			_scroller.addEventListener(Event.CHANGE, changeHandler);
		}
		
		/**
		 * 移除事件侦听
		 */
		private function unlisten():void
		{
			_layout.removeEventListener(Event.CHANGE, changeHandler);
			_scroller.removeEventListener(Event.CHANGE, changeHandler);
		}
		
		/**
		 * 更新渲染
		 * @param	e
		 */
		private function changeHandler(e:Event):void 
		{
			if(e.currentTarget == _scroller)
			{
				_layout.value = _scroller.value;
			}
			else
			{
				_scroller.value = _layout.value;
			}
		}
		
		/* INTERFACE com.qzone.corelib.controls.interfaces.IController */
		// getter & setter
		//*************************************************
		/**
		 * 激活控件
		 */
		public function get enabled():Boolean { return _enabled; }
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
			
			_layout.enabled = _enabled;
			_scroller.enabled = _enabled;
			
			_enabled? listen() : unlisten();
		}
		
		/**
		 * 代理布局列表数据
		 */
		public function get dataProvider():Array { return _layout.dataProvider; }
		public function set dataProvider(value:Array):void 
		{
			_layout.dataProvider = value || [];
			_scroller.lineCount = _layout.lineCount;
			
			refresh();
		}
		
		/**
		 * 滚动控件
		 */
		public function get scroller():IScroller { return _scroller; }
		
		/**
		 * 布局控件
		 */
		public function get layout():ScrollLayout { return _layout; }
		
		/**
		 * 列表项目渲染类
		 */
		public function get itemRenderClass():Class { return _layout.itemRenderClass; }
		public function set itemRenderClass(value:Class):void 
		{
			_layout.itemRenderClass = value;
		}
		
		/**
		 * 列表是否为竖直布局
		 */
		public function get virtical():Boolean { return _virtical; }
		
	}

}