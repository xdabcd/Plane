package game.object
{
	import data.UserInfo;

	import element.PlayerElement;

	import laya.ui.Label;
	import laya.utils.Pool;

	import math.Utils;

	public class Plane extends BaseGameObject 
	{	
		public var nameLabel: Label;

		public function Plane()
		{
			super();
			ele = new PlayerElement;
			nameLabel = new Label;
			nameLabel.fontSize = 30;
			nameLabel.align = "center";
			nameLabel.width = 300;
			nameLabel.color = "#ffffff";
			nameLabel.anchorX = 0.5;

			scale(0.5, 0.5);
		}

		public function setName(name: String):void
		{
			this.nameLabel.text = name;
		}

		public function setSkin(skin: int):void
		{
			loadImage("plane/plane_" + skin + ".png");
			pivotX = width / 2;
			pivotY = height / 2;
		}

		public function changeDireciotn(direction: Number):void
		{
			(ele as PlayerElement).direction = direction;
		}

		override public function update():void
		{
			super.update();
			var dir: Number = (ele as PlayerElement).direction;
			rotation = Utils.dirToAngle(dir);

			nameLabel.x = x; 
			nameLabel.y = y - 50;
		}

		override public function sync(info: *):void
		{
			var userInfo: UserInfo = info;
			var playerEle: PlayerElement = ele as PlayerElement;
			playerEle.setPos(userInfo.x, userInfo.y);
			playerEle.speed = userInfo.speed;
			playerEle.direction = userInfo.direction;
		}

		override public function recover():void
		{
			super.recover();
			Pool.recover("Plane", this);
			nameLabel.parent && nameLabel.parent.removeChild(nameLabel);
		}
	}
}

