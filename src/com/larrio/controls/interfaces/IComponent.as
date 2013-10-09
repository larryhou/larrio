package com.larrio.controls.interfaces 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 控制器接口
	 * @author larryhou
	 */
	public interface IComponent extends IEventDispatcher
	{
		/**
		 * 是否激活控件
		 */
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
	}
	
}