package com.larrio.controls.interfaces 
{
	
	/**
	 * 可拖动控件接口
	 * @author larryhou
	 * @createTime	2010/2/22 21:24
	 */
	public interface IDragComponent 
	{		
		/**
		 * 速度感应临界值
		 */
		function get threshold():Number;
		function set threshold(value:Number):void;
		
		/**
		 * 停止拖动后减速缓动函数
		 */
		function get ease():Function;
		function set ease(value:Function):void;
		
		/**
		 * ease缓动持续时间
		 */
		function get duration():Number;
		function set duration(value:Number):void;
	}
	
}