package
{
	import com.larrio.controls.interfaces.IRender;
	import com.larrio.controls.wrappers.RenderWrapper;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Oct 9, 2013 10:51:08 AM
	 */
	public class SimpleItemRender extends Sprite implements IRender
	{
		private var _data:Object;
		private var _label:TextField;
		
		/**
		 * 构造函数
		 * create a [SimpleItemRender] object
		 */
		public function SimpleItemRender()
		{
			mouseChildren = false;
			graphics.beginFill(0xEEEEEE, 1);
			graphics.drawRect(0,0, 200, 120);
			graphics.endFill();
			
			_label = new TextField();
			_label.defaultTextFormat = new TextFormat("Consolas", 30, true,null,null,null,null,null, "center");
			_label.selectable = false;
			_label.width = 200;
			_label.height = 30;
			_label.y = (120 - _label.height) / 2;
			addChild(_label);
			
		}
		
		private function render():void
		{
			_label.text = String(_data.id);
			trace(RenderWrapper(parent).dataIndex);
		}

		public function get data():Object { return _data; }
		public function set data(value:Object):void
		{
			_data = value;
			_data && render();
		}

	}
}