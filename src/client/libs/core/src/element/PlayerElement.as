package element
{
	import data.UserInfo;

	import laya.maths.Point;

	public class PlayerElement extends MoveElement 
	{
		public var userInfo: UserInfo
		public var isDead:Boolean = false;

		public function PlayerElement()
		{
			super();
			userInfo = new UserInfo;
		}

		public function updateUserInfo():void
		{
			var position: Point = getPos();
			userInfo.x = position.x;
			userInfo.y = position.y;
			userInfo.speed = speed;
			userInfo.direction = direction;
		}
	}
}

