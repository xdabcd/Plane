package element
{
	import laya.maths.Point;

	import math.Utils;

	public class MoveElement extends BaseElement
	{
		public var speed: Number = 0;
		public var direction: Number = 0;
		public var moveable: Boolean;

		public function MoveElement()
		{
			super();

			moveable = true;
		}

		override public function update(delta: Number):void
		{
			if(moveable)
			{
				var vec: Point = Utils.dirToVec(direction);
				rect.x += speed * delta * vec.x;
				rect.y += speed * delta * vec.y;
			}
		}

	}
}

