package com.larrio.controls.wrappers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.text.TextField;

	/**
	 * 按钮素材包装器
	 * @author larryhou
	 */
	public class ButtonWrapper extends MovieClip
	{
		private var _clipView:DisplayObject;
		
		/**
		 * 构造函数
		 * create a [ButtonWrapper] object
		 */
		public function ButtonWrapper(clipView:DisplayObject)
		{
			_clipView = clipView;
			
			if (!_clipView)
			{
				throw new ArgumentError("构造" + this + "实例时必须传入有效地参数！");
			}
			
			if (_clipView is MovieClip)
			{
				(_clipView as MovieClip).stop();
				(_clipView as MovieClip).mouseEnabled = false;
				(_clipView as MovieClip).mouseChildren = false;
			}
			else
			if (_clipView is SimpleButton)
			{
				this.mouseEnabled = false;
			}
			else
			{
				this.mouseChildren = false;
			}
			
			if (!_clipView.parent)
			{
				throw new ArgumentError(_clipView + "的父级容器不能为null！");
			}
			
			_clipView.parent.addChild(this);
			
			addChild(_clipView);
		}
		
		//------------------------------------------
		// Public APIs
		//------------------------------------------
		
		override public function gotoAndStop(frame:Object, scene:String = null):void 
		{
			if(_clipView is MovieClip)
			{
				(_clipView as MovieClip).gotoAndStop(frame, scene);
			}			
		}
		
		override public function gotoAndPlay(frame:Object, scene:String = null):void 
		{
			if(_clipView is MovieClip)
			{
				(_clipView as MovieClip).gotoAndPlay(frame, scene);
			}
		}
		
		override public function nextFrame():void 
		{
			if(_clipView is MovieClip)
			{
				(_clipView as MovieClip).nextFrame();
			}
		}
		
		override public function prevFrame():void 
		{
			if(_clipView is MovieClip)
			{
				(_clipView as MovieClip).prevFrame();
			}
		}
		
		override public function stop():void
		{
			if(_clipView is MovieClip)
			{
				(_clipView as MovieClip).stop();
			}
		}
		
		override public function play():void 
		{
			if(_clipView is MovieClip)
			{
				(_clipView as MovieClip).play();
			}
		}
		
		//------------------------------------------
		// Getters & Setters
		//------------------------------------------
		
		override public function get numChildren():int
		{ 
			if(_clipView is DisplayObjectContainer)
			{
				return (_clipView as DisplayObjectContainer).numChildren;
			}
			
			return super.numChildren;
		}
		
		override public function get totalFrames():int 
		{
			if(_clipView is MovieClip)
			{
				return (_clipView as MovieClip).totalFrames;
			}
			
			return super.totalFrames;
		}
		
		override public function get currentFrame():int
		{
			if(_clipView is MovieClip)
			{
				return (_clipView as MovieClip).currentFrame;
			}
			
			return super.currentFrame;
		}
		
		override public function get scenes():Array 
		{
			if(_clipView is MovieClip)
			{
				return (_clipView as MovieClip).scenes;
			}
			
			return super.scenes;
		}
		
		/**
		 * 获取按钮标签
		 */
		public function get label():TextField 
		{ 
			if (_clipView && _clipView.hasOwnProperty("label"))
			{
				return _clipView["label"];
			}
			
			return null;
		}
		
		public function set label(value:TextField):void 
		{
			try
			{
				_clipView["label"] = value;
			}
			catch (e:Error) { }
		}
		
		override public function get mouseEnabled():Boolean { return super.mouseEnabled; }
		override public function set mouseEnabled(value:Boolean):void 
		{
			super.mouseEnabled = value;
			
			if (_clipView is InteractiveObject)
			{
				(_clipView as InteractiveObject).mouseEnabled = value;
			}
			
			if (_clipView is SimpleButton)
			{
				(_clipView as SimpleButton).enabled = value;
			}
		}
	}

}