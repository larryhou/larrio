package com.larrio.controls.buttons 
{
	import flash.display.DisplayObject;
	import flash.text.TextFormat;

	/**
	 * 带有自定义标签的按钮
	 * @author larryhou
	 */
	public class LabelButton extends Button
	{
		private var _label:String = "";		
		private var _format:TextFormat = null;
		
		/**
		 * 构造函数
		 * create a [LabelButton] object
		 */
		public function LabelButton(buttonView:DisplayObject, useWrapper:Boolean = false)
		{
			super(buttonView, useWrapper);
			
			_label = _buttonView["label"];
			
			if (!_label)
			{
				throw new ArgumentError(this + "按钮标签文本框必须命名为label！");
			}
		}
		
		override protected function setButtonState(state:String):void 
		{
			super.setButtonState(state);
			
			this.label = (_label ||= "");
		}
		
		/**
		 * 标签文字
		 */
		public function get label():String { return _label; }
		public function set label(value:String):void
		{
			_label = value;
			_buttonView["label"].text = _label;
		}
		
	}

}