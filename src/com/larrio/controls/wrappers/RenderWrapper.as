package com.larrio.controls.wrappers
{	
	import com.larrio.controls.interfaces.IRender;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 列表渲染器包装器
	 * @author larryhou
	 */
	public class RenderWrapper extends Sprite
	{
		private var _data:Object = null;
		
		private var _index:int = 0;
		private var _dataIndex:int = 0;
		
		private var _scrolling:Boolean = false;
		
		private var _target:IRender = null;
		
		/**
		 * 构造函数
		 * create a [RenderWrapper] object 
		 * @param	RenderClass		渲染器类
		 */
		public function RenderWrapper(RenderClass:Class)
		{
			_target = new RenderClass() as IRender;
			if (_target is DisplayObject)
			{
				addChild(_target as DisplayObject);
				
				if (this.width == 0 || this.height == 0)
				{
					throw new ArgumentError(_target + "高度或者宽度为0，这样会导致布局控件的遮罩宽高计算错误！");
				}
			}
			else
			{
				throw new ArgumentError(RenderClass + "必须实现IRenderer接口，并且继承显示对象类！");
			}
		}		
		
		/**
		 * 数据，如果必要，需要将data转换成特定类型
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			_data = value;
			_target.data = value;
		}
		
		/**
		 * 视图索引
		 */
		public function get index():int { return _index; }
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		/**
		 * 数据索引
		 */
		public function get dataIndex():int { return _dataIndex; }
		public function set dataIndex(value:int):void 
		{
			_dataIndex = value;
		}
		
		/**
		 * 优先使用Renderer的高度
		 */
		override public function get height():Number { return DisplayObject(_target).height; }
		
		/**
		 * 优先使用Renderer的宽度
		 */
		override public function get width():Number { return DisplayObject(_target).width; }
		
		/**
		 * 渲染器实例对象
		 */
		public function get target():IRender { return _target; }
		
		/**
		 * 是否正在滚动
		 */
		public function get scrolling():Boolean { return _scrolling; }
		public function set scrolling(value:Boolean):void
		{
			_scrolling = value;
		}
	}

}