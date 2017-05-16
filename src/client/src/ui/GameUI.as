/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class GameUI extends View {
		public var bg:Image;
		public var planeBox:Box;

		public static var uiView:Object ={"type":"View","props":{"width":1136,"height":640,"centerY":0,"centerX":0},"child":[{"type":"Image","props":{"y":320,"x":568,"var":"bg","skin":"bg.jpg","anchorY":0.5,"anchorX":0.5}},{"type":"Box","props":{"y":320,"x":568,"var":"planeBox"}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}