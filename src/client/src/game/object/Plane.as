package game.object
{
	import data.UserInfo;

	import element.PlayerElement;

	import laya.utils.Pool;

	import math.Utils;

	public class Plane extends BaseGameObject 
	{	
		public function Plane()
		{
			super();
			ele = new PlayerElement;
		}

		public function setName(name: String):void
		{

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
		}
	}
}

