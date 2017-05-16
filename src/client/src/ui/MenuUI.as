/**Created by the LayaAirIDE,do not modify.*/
package ui {
	import laya.ui.*;
	import laya.display.*; 

	public class MenuUI extends View {
		public var bg:Image;
		public var nameInput:TextInput;
		public var startBtn:Button;

		public static var uiView:Object ={"type":"View","props":{"width":1136,"height":640,"centerY":0,"centerX":0},"child":[{"type":"Image","props":{"y":320,"x":568,"var":"bg","skin":"bg.jpg","anchorY":0.5,"anchorX":0.5}},{"type":"TextInput","props":{"y":200,"x":418,"width":300,"var":"nameInput","skin":"comp/textinput.png","prompt":"Your NickName","height":100,"fontSize":40,"font":"SimHei","align":"center"}},{"type":"Button","props":{"y":339.9999999999999,"x":418,"width":300,"var":"startBtn","skin":"comp/button.png","labelSize":40,"labelFont":"SimHei","label":"Start","height":100}}]};
		override protected function createChildren():void {
			super.createChildren();
			createView(uiView);
		}
	}
}