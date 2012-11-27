package com.larrio.controls.interfaces
{
	
	
	/**
	 * 滚动控件接口
	 * @author larryhou
	 */
	public interface IScroller extends IController
	{
		/**
		 * 滑块值，是一个百分比，介于0~100
		 */
		function get value():Number;
		function set value(position:Number):void;
		
		/**
		 * 设置当前行数量
		 */
		function get lineCount():int;
		function set lineCount(value:int):void;
		
		/**
		 * 兼容老组件，新组件已废弃并由lineCount替代
		 * @private
		 */
		function setCurrentLineCount(value:int):void;
	}
}