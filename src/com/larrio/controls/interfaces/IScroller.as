package com.larrio.controls.interfaces
{
	
	
	/**
	 * 滚动控件接口
	 * @author larryhou
	 */
	public interface IScroller extends IComponent
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
	}
}