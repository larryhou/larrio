package com.larrio.controls.buttons 
{
	import flash.display.DisplayObject;
	
	/**
	 * 可选择按钮
	 * @author larryhou
	 */
	public class TabButton extends LabelButton
	{
		protected var _selected:Boolean = false;
		
		/**
		 * 构造函数
		 * create a [TabButton] object
		 */
		public function TabButton(buttonView:DisplayObject, useWrapper:Boolean = false) 
		{
			super(buttonView, useWrapper);
		}
		
		/**
		 * 是否被选择
		 */
		public function get selected():Boolean { return _selected; }
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			if (!_selected)
			{
				this.frameLabelPrefix = "";
			}
			else
			{
				this.frameLabelPrefix = "selected";
			}
			
			_buttonView.buttonMode = !_selected;
		}	
	}

}