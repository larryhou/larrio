package com.larrio.controls.scrollers.bar 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	/**
	 * 简单滑块素材
	 * @author larryhou
	 * @createTime 2012/5/28 18:09
	 */
	public dynamic class BarView extends MovieClip
	{
		private var _bar:MovieClip;
		private var _track:MovieClip;
		
		/**
		 * 构造函数
		 * create a [BarView] object
		 */
		public function BarView()
		{
			init();
		}
		
		/**
		 * 初始化界面
		 */
		private function init():void 
		{
			var _canvas:Graphics;
			
			var _radius:Number = 15;
			
			// add track
			_track = new MovieClip();
			_track.name = "track";
			_canvas = _track.graphics;
			_canvas.beginFill(0xEFEFEF, 1);
			_canvas.lineStyle(0.001, 0x000000, 0);
			_canvas.drawRoundRectComplex(0, 0, 10, 200, _radius, _radius, _radius, _radius);
			_track.scale9Grid = new Rectangle(4, 20, 2, 160);	// 九宫格缩放
			addChild(_track);
			
			// 添加边框
			_track.filters = [new GlowFilter(0xCCCCCC, 1, 2, 2, 10, 1, false)];
			
			// add bar
			_bar = new MovieClip();
			_bar.name = "bar";
			_canvas = _bar.graphics;
			_canvas.beginFill(0xCCCCCC, 1);
			_canvas.lineStyle(0.001, 0x000000, 0);
			_canvas.drawRoundRectComplex(0, 0, 10, 50, _radius, _radius, _radius, _radius);
			_bar.scale9Grid = new Rectangle(4, 20, 2, 10);	// 九宫格缩放
			addChild(_bar);
			
			// 位图缓存
			_bar.filters = [new ColorMatrixFilter()];
		}
		
		// getter & setter
		//*************************************************
		/**
		 * 滑块
		 */
		public function get bar():MovieClip { return _bar; }
		
		/**
		 * 滑轨
		 */
		public function get track():MovieClip { return _track; }
		
	}

}