package
{
	import com.larrio.controls.layouts.EasyLayout;
	
	import flash.display.Sprite;
	
	[SWF(width="1024", height="768", frameRate="60")]
	
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Oct 8, 2013 8:55:40 PM
	 */
	public class Main extends Sprite
	{
		/**
		 * 构造函数
		 * create a [Main] object
		 */
		public function Main()
		{
			var layout:EasyLayout = new EasyLayout(5, 3,5,5,true);
			layout.itemRenderClass = SimpleItemRender;
			addChild(layout.layout);
			
			var provider:Array = [];
			while (provider.length < 100) provider.push({id:provider.length + 1});
			
			layout.dataProvider = provider;
			layout.enabled = true;
		}
	}
}