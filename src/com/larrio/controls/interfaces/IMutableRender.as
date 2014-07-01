package com.larrio.controls.interfaces 
{	
	/**
	 * 变高度渲染接口
	 * @author larryhou
	 * create a [IMutableRender] interface
	 */
	public interface IMutableRender extends IRender
	{
		/**
		 * 计算给定数据的渲染器高度
		 * @param	data	渲染器数据
		 * @return	渲染器高度
		 */
		function caculateHeight(data:Object):uint;
	}
	
}